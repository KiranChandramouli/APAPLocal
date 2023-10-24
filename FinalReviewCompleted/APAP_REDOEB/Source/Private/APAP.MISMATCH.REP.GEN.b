* @ValidationCode : MjoxNjg1MDc3MDExOkNwMTI1MjoxNjkyODc3ODk2NDQ5OklUU1M6LTE6LTE6MTA5NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Aug 2023 17:21:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1094
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE APAP.MISMATCH.REP.GEN
* 02/01/2017 - Sunder - ITSS
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*21-08-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.COMPANY


    FN.CONSOL.MISMATCH = 'F.CONSOL.MISMATCHES'
    F.CONSOL.MISMATCH = ''
    CALL OPF(FN.CONSOL.MISMATCH,F.CONSOL.MISMATCH)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    Y.CONSOL.REP.ARR = ''
    Y.CONSOL.REP.ARR = "Line ID,Line Description,Company id,Company Description,Mismatch Key,CAL/CPL Balance,Contract Balance,Difference"

    Y.SEL.CMD = 'SELECT ':FN.CONSOL.MISMATCH
    CALL EB.READLIST(Y.SEL.CMD,Y.LIST,'','',Y.ERR)
    LOOP
        REMOVE Y.CON.MIS.ID FROM Y.LIST SETTING MIS.POS
    WHILE Y.CON.MIS.ID:MIS.POS
        CALL F.READ(FN.CONSOL.MISMATCH,Y.CON.MIS.ID,R.CONSOL.MISMATCH,F.CONSOL.MISMATCH,Y.MIS.ERR)
        IF R.CONSOL.MISMATCH THEN

            Y.LINE.ID = '' ; Y.LINE.DESC = '' ; Y.COMPANY.ID = '' ; Y.COMPANY.DESC = ''
            Y.MIS.KEY = '' ; Y.BAL = '' ; Y.CONT.BAL = '' ; Y.DIFF = ''

            Y.MIS.KEY = R.CONSOL.MISMATCH<1>
            Y.BAL = R.CONSOL.MISMATCH<3>
            Y.CONT.BAL = R.CONSOL.MISMATCH<2>
            Y.DIFF = R.CONSOL.MISMATCH<4>
            Y.LINE.ID = FIELD(R.CONSOL.MISMATCH<5>,'.',1,2)
            Y.COMPANY.ID = FIELD(R.CONSOL.MISMATCH<5>,'.',3,1)

            CALL F.READ(FN.COMPANY,Y.COMPANY.ID,R.COMP,F.COMPANY,Y.COMP.ERR)
            Y.COMPANY.DESC = R.COMP<EB.COM.COMPANY.NAME>

            CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE.ID,R.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE,Y.LINE.ERR)
            Y.LINE.DESC = R.RE.STAT.REP.LINE<RE.SRL.DESC,2>

            Y.CONSOL.REP.ARR<-1> = Y.LINE.ID:",":Y.LINE.DESC:",":Y.COMPANY.ID:",":Y.COMPANY.DESC:",":Y.MIS.KEY:",":Y.BAL:",":Y.CONT.BAL:",":Y.DIFF

        END

    REPEAT

    IF Y.CONSOL.REP.ARR THEN
*        F.SAVEDLISTS = ''
*        OPEN '','&SAVEDLISTS&' TO F.SAVEDLISTS ELSE         ;* Open the savedlists and store its path
*            ERR.OPEN ='Cannot Open &SAVEDLISTS&'
*        END

        OPEN '','../bnk.interface/REG.REPORTS/CRBs/CRD' TO F.REP.DIR ELSE
            EXECUTE 'CREATE-FILE DATA ../bnk.interface/REG.REPORTS/CRBs/CRD TYPE=UD'
            OPEN '','../bnk.interface/REG.REPORTS/CRBs/CRD' TO F.REP.DIR ELSE
                ERR.OPEN ='Cannot Open Path ../bnk.interface/REG.REPORTS/CRBs/CRD'
                CRT ERR.OPEN
                EXIT(1)
            END
        END

        Y.CONSOL.REP.ID = TODAY:"_Mismatch_Report.csv"
        Y.CONSOL.REP.ARR = SORT(Y.CONSOL.REP.ARR)
*        WRITE Y.CONSOL.REP.ARR TO F.SAVEDLISTS,Y.CONSOL.REP.ID
        WRITE Y.CONSOL.REP.ARR TO F.REP.DIR,Y.CONSOL.REP.ID

    END
RETURN
END
