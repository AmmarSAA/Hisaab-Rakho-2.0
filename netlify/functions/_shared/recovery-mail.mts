import {createHmac,timingSafeEqual} from 'node:crypto';
import nodemailer from 'nodemailer';
type GetEnv=(name:string)=>string|undefined;
type Send=(options:object,message:object)=>Promise<void>;
function address(value:unknown):value is string{return typeof value==='string'&&value.length<=254&&/^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)+$/.test(value);}
async function body(request:Request){const reader=request.body?.getReader();if(!reader)throw Error('body');const chunks:Uint8Array[]=[];let length=0;while(true){const {done,value}=await reader.read();if(done)break;length+=value.length;if(length>8192){await reader.cancel();throw Error('size');}chunks.push(value);}return Buffer.concat(chunks).toString('utf8');}
async function smtp(options:object,message:object){const transport=nodemailer.createTransport(options);try{const result=await transport.sendMail(message);if(result.rejected?.length||!result.accepted?.length)throw Error('delivery');}finally{transport.close();}}
export async function relay(request:Request,get:GetEnv,send:Send=smtp,now=Date.now()) {
 const respond=(status:number)=>new Response(status===200?'OK':'Request unavailable',{status,headers:{'Cache-Control':'no-store','Content-Type':'text/plain','X-Content-Type-Options':'nosniff'}});
 if(request.method!=='POST')return respond(405);
 const secret=get('RECOVERY_RELAY_SECRET');if(!secret||secret.length<32)return respond(503);
 const timestamp=request.headers.get('X-Hisaab-Timestamp')||'',signature=request.headers.get('X-Hisaab-Signature')||'';
 if(!/^\d{13}$/.test(timestamp)||Math.abs(now-Number(timestamp))>300000||! /^[a-f0-9]{64}$/.test(signature))return respond(401);
 let raw;try{raw=await body(request);}catch{return respond(413);}
 const expected=createHmac('sha256',secret).update(timestamp+'\n'+raw).digest();
 if(!timingSafeEqual(expected,Buffer.from(signature,'hex')))return respond(401);
 let input;try{input=JSON.parse(raw);}catch{return respond(400);}
 if(!input||typeof input!=='object'||Array.isArray(input)||Object.keys(input).some(key=>!['email','resetUrl'].includes(key))||!address(input.email)||typeof input.resetUrl!=='string')return respond(400);
 let link;try{link=new URL(input.resetUrl);}catch{return respond(400);}
 if(link.origin!=='https://hisaab-private-api.s-ammarahmed14.workers.dev'||link.pathname!=='/reset'||link.search||link.username||link.password||!/^#[a-f0-9]{64}$/.test(link.hash))return respond(400);
 const host=get('SMTP_HOST'),port=Number(get('SMTP_PORT')||465),user=get('SMTP_USER'),pass=get('SMTP_PASS'),from=get('MAIL_FROM')||user;
 if(!host||!/^[A-Za-z0-9.-]+$/.test(host)||![465,587].includes(port)||!user||!pass||!address(from))return respond(503);
 const options={host,port,secure:port===465,requireTLS:true,auth:{user,pass},tls:{rejectUnauthorized:true,servername:host},pool:false,logger:false,debug:false,connectionTimeout:10000,greetingTimeout:10000,socketTimeout:15000,disableFileAccess:true,disableUrlAccess:true};
 try{await send(options,{from:{name:'Hisaab Rakho',address:from},to:input.email,subject:'Reset your Hisaab Rakho password',text:`A password reset was requested for your Hisaab Rakho account.\n\nOpen this single-use link within 30 minutes:\n${link.href}\n\nIf you did not request this, ignore this email. Your password has not changed.`,disableFileAccess:true,disableUrlAccess:true});return respond(200);}catch{return respond(503);}
}
