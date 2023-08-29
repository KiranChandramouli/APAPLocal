* @ValidationCode : MjoyMDExODgzMzI6Q3AxMjUyOjE2OTMzMTE0NjY5NjA6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 29 Aug 2023 17:47:46
* @ValidationInfo : Encoding          : Cp1252
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
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   T24.BP REMOVED , DCOUNT FORMAT CAN BE MODIFIED
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION PATH IS MODIFIED
*----------------------------------------------------------------------------------------




PROGRAM COPY.REPORTS.MISMATCH

    $INSERT I_F.DATES ;*R22 AUTO CODE CONVERSION

    FV.DATES = ''
    OPEN 'F.DATES' TO FV.DATES ELSE STOP 201

    TODAY.REC = ''
    READ TODAY.REC FROM FV.DATES,'DO0010001' THEN
        TODAY.VAR = TODAY.REC<EB.DAT.TODAY>

        SEL.CMD = 'SELECT F.HOLD.CONTROL WITH REPORT.NAME EQ CRD.MBGL CRD.MBPL AND BANK.DATE EQ ':TODAY.VAR
*        SEL.CMD = 'SELECT F.HOLD.CONTROL WITH REPORT.NAME EQ CRD.MBGL CRD.MBPL'
        EXECUTE SEL.CMD CAPTURING OUTPUT
        READLIST REC.LIST ELSE REC.LIST = ''

        CNT = DCOUNT(REC.LIST,@FM)
        FOR REC.IDX = 1 TO CNT ;*R22 AUTO CODE CONVERSION
            PRINT 'Copying ':REC.LIST<REC.IDX>
*         EXECUTE 'COPY FROM &HOLD& TO ../bnk.interface/REG.REPORTS/CRBs/CRD ':REC.LIST<REC.IDX> ;*R22 Manual Conversion PATH IS MODIFIED
            EXECUTE 'SH -c cp &HOLD&/':REC.LIST<REC.IDX>:'../bnk.interface/REG.REPORTS/CRBs/CRD/':REC.LIST<REC.IDX>
        NEXT REC.IDX
    END
 
RETURN

END
