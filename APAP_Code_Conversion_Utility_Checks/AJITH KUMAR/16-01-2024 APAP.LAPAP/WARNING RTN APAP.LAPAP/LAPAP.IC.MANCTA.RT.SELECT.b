* @ValidationCode : MjoxMTA1MzE4NTM6VVRGLTg6MTY5MDE2NzkxMDIyNzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:35:10
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.IC.MANCTA.RT.SELECT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 13-07-2023    Narmadha V             R22 Manual Conversion   BP is removed in insert file
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.DATES
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.CUSTOMER.ACCOUNT
    $INSERT  I_F.ST.LAPAP.EMP.COM.PAR
    $INSERT  I_LAPAP.IC.MANCTA.RT.COMMON
   $USING EB.Service

    GOSUB DO.SELECT
RETURN

DO.SELECT:

    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.CUS : " WITH CUSTOMER.STATUS EQ 1 AND L.CU.TIPO.CL EQ 'PERSONA JURIDICA'"

    CALL OCOMO("RUNNING WITH SELECT LIST : " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.REC)
EB.Service.BatchBuildList('',SEL.REC);* R22 UTILITY AUTO CONVERSION

RETURN

END
