* @ValidationCode : MjotMTQ3NDQ3NDI0MzpDcDEyNTI6MTY5MzMxMzcxMzQ2ODpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 29 Aug 2023 18:25:13
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
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  T24.BP is removed , DCOUNT format can be changed
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*25-08-2023       VIGNESHWARI                 MANUAL R22 CODE CONVERSION  PATH IS MODIFIED  
*----------------------------------------------------------------------------------------
* Realializado por Elvis, Lo siguiente obtendra la fecha al dia.
PROGRAM COPY.REPORTS.NW
    $INSERT I_F.DATES ;*R22 AUTO CODE CONVERSION

    FV.DATES = ''
    OPEN 'F.DATES' TO FV.DATES ELSE STOP 201

    TODAY.REC = ''
    READ TODAY.REC FROM FV.DATES,'DO0010001' THEN
        TODAY.VAR = TODAY.REC<EB.DAT.TODAY>
*        TODAY.VAR = TODAY.REC<EB.DAT.LAST.WORKING.DAY>
*        SEL.CMD = 'SELECT F.HOLD.CONTROL WITH REPORT.NAME EQ CRB.MBGL AND DATE.CREATED EQ ':TODAY.VAR
        SEL.CMD = 'SELECT F.HOLD.CONTROL WITH REPORT.NAME EQ CRB.NWGL AND BANK.DATE EQ ':TODAY.VAR
        EXECUTE SEL.CMD CAPTURING OUTPUT
        READLIST REC.LIST ELSE REC.LIST = ''

        CNT = DCOUNT(REC.LIST,@FM)
        FOR REC.IDX = 1 TO CNT ;*R22 AUTO CODE CONVERSION
            PRINT 'Copying ':REC.LIST<REC.IDX>
            *EXECUTE 'COPY FROM &HOLD& TO ../bnk.interface/REG.REPORTS/CRBs/NWGL ':REC.LIST<REC.IDX>
            EXECUTE 'sh -c cp  &HOLD& : /':REC.LIST<REC.IDX>' ': '../bnk.interface/REG.REPORTS/CRBs/NWGL' :'/':REC.LIST<REC.IDX>  ;*R22 MANUAL CONVERSION - PATH IS MODIFIED
            
        NEXT REC.IDX
    END

RETURN

END
