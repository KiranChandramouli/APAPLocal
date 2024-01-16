* @ValidationCode : Mjo3MTM2ODcyMDY6Q3AxMjUyOjE3MDUzODExMTMyMjI6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Jan 2024 10:28:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.REC.ACCT.LIST.SELECT

** 24-04-2023 R22 Auto Conversion
** 24-04-2023 Skanda R22 Manual Conversion - No changes

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
  *  $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_REDO.B.REC.ACCT.LIST.COMMON ;* R22 Auto conversion
   $USING EB.Service

    GOSUB PROCESS
RETURN

********
PROCESS:
********

    FINAL.OUT.FILE.NAME = FILE.NAME:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'

    OPENSEQ OUT.PATH,FINAL.OUT.FILE.NAME TO Y.FIN.PTR THEN
        CALL F.DELETE(OUT.PATH,FINAL.OUT.FILE.NAME)
    END

    SEL.CMD = 'SELECT ': FN.ACCOUNT :" WITH CATEGORY GE ":DEF.ST.CATEG:" AND CATEGORY LE ":DEF.ED.CATEG
    CALL EB.READLIST(SEL.CMD,Y.ACCT.LIST,'',NO.OF.REC.RE,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',Y.ACCT.LIST)
EB.Service.BatchBuildList('',Y.ACCT.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
END
