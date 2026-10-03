import type {Config,Context} from '@netlify/functions';
import {relay} from './_shared/recovery-mail.mts';
export default async (request:Request,_context:Context)=>relay(request,name=>Netlify.env.get(name));
export const config:Config={path:'/api/recovery-mail'};
