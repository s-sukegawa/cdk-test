#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { SandboxStack } from "../lib/sandbox-stack";

const app = new cdk.App();

new SandboxStack(app, "SandboxStack", {
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION ?? process.env.AWS_REGION ?? "ap-northeast-1",
  },
});
