* @ValidationCode : MjoxMTg5ODQwMjM6VVRGLTg6MTcwMjQ3MDE3NjY5MjpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Dec 2023 17:52:56
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.BM
PROGRAM COPY.REPORTS
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   INSERT FILE MODIFIED, DCOUNT CAN BE MODIFIED
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION PATH IS MODIFIED
*13-12-2023       Narmadha V                  Manual R22 Conversion      intialise Fn variable,Changed Hardcoded value to FN variable
*----------------------------------------------------------------------------------------
* Realializado por Elvis, Lo siguiente obtendra la fecha al dia.
    
    $INSERT I_F.DATES ;*R22 AUTO CODE CONVERSION
    FN.DATES ="F.DATES" ;*Manual R22 Conversion - intialise Fn variable
    FV.DATES = ''
*OPEN 'F.DATES' TO FV.DATES ELSE STOP 201
    OPEN FN.DATES TO FV.DATES ELSE STOP 201 ;*Manual R22 conversion - Changed Hardcoded value to FN variable

    TODAY.REC = ''
    READ TODAY.REC FROM FV.DATES,'DO0010001' THEN
        TODAY.VAR = TODAY.REC<EB.DAT.TODAY>
*        TODAY.VAR = TODAY.REC<EB.DAT.LAST.WORKING.DAY>
*        SEL.CMD = 'SELECT F.HOLD.CONTROL WITH REPORT.NAME EQ CRB.MBGL AND DATE.CREATED EQ ':TODAY.VAR
        SEL.CMD = 'SELECT F.HOLD.CONTROL WITH REPORT.NAME EQ CRB.MBGL AND BANK.DATE EQ ':TODAY.VAR
        EXECUTE SEL.CMD CAPTURING OUTPUT
        READLIST REC.LIST ELSE REC.LIST = ''

        CNT = DCOUNT(REC.LIST,@FM);*R22 AUTO CODE CONVERSION
        FOR REC.IDX = 1 TO CNT
            PRINT 'Copying ':REC.LIST<REC.IDX>
*       EXECUTE 'COPY FROM &HOLD& TO ../bnk.interface/REG.REPORTS/CRBs ':REC.LIST<REC.IDX> ;*R22 Manual Conversion
            EXECUTE 'SH -c cp &HOLD&/':REC.LIST<REC.IDX>:' ':'../bnk.interface/REG.REPORTS/CRBs/':REC.LIST<REC.IDX>
        NEXT REC.IDX
    END
 
RETURN

END
