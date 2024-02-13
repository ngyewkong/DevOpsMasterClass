#!/bin/bash
dotnet test --logger "trx;LogFileName=Pi.Math.trx" jenkins/sample_project/src/Pi.Math.Tests/Pi.Math.Tests.csproj
dotnet test --logger "trx;LogFileName=Pi.Runtime.trx" jenkins/sample_project/src/Pi.Runtime.Tests/Pi.Runtime.Tests.csproj