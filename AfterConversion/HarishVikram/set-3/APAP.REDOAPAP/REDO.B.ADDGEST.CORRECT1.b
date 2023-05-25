* @ValidationCode : MjotNTg4MTc3Mzc2OkNwMTI1MjoxNjg1MDExODY5MzAxOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 May 2023 16:21:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.B.ADDGEST.CORRECT1
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                DESCRIPTION
*25-05-2023           Conversion Tool          R22 Auto Code conversion             No Changes
*25-05-2023           Harishvikram C          Manual R22 Code Conversion         No Changes
*
*---------------------------------------- -------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_REDO.B.ADDGEST.CORRECT.COMMON

****GETTING ARRANGEMENT ID*****
    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT = ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.TEMP.FILE.PATH = '&TEMP&'
    OPEN FN.TEMP.FILE.PATH TO F.TEMP.FILE.PATH ELSE
    END
****FILE UPLOAD LOCATION***

    FN.SL = '&SAVEDLISTS&'
    F.SL = ''
    CALL OPF(FN.SL,F.SL)

    FN.AA.REF = "F.AA.ARRANGEMENT.DATED.XREF"
    F.AA.REF = ""
    CALL OPF(FN.AA.REF,F.AA.REF)

    CALL F.READ(FN.SL,'REDO.AA.CORRECT1',ID.LIST,F.SL,RET.ERROR)

    TEMP.ARRAY.LIST = ''
    LOOP
        REMOVE ARR.ID.LIST FROM ID.LIST SETTING SEL.POS
    WHILE ARR.ID.LIST:SEL.POS
        ARR.ID = FIELD(ARR.ID.LIST,'|',1)
        Y.ALT.ID = FIELD(ARR.ID.LIST,'|',2)
        IF ARR.ID NE '' THEN
            CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
            IF R.AA.ARRANGEMENT THEN
                ACCT.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
                CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
                R.ACCOUNT<AC.ALT.ACCT.ID,4,1> = Y.ALT.ID
                WRITE R.ACCOUNT TO F.ACCOUNT,ACCT.ID

                CALL F.READ(FN.AA.REF,ARR.ID,R.AA.REF,F.AA.REF,YERR2)
                PROP.LIST = R.AA.REF<1>
                DATE.LIST = R.AA.REF<2>
                CHANGE @VM TO @FM IN PROP.LIST
                CHANGE @VM TO @FM IN DATE.LIST

                LOCATE "ACCOUNT" IN PROP.LIST SETTING PROP.POS THEN
                    ACC.DATE.LIST = ''
                    ACC.DATE.LIST = DATE.LIST<PROP.POS>
                    CHANGE @SM TO @FM IN ACC.DATE.LIST
                    FINAL.DATE = ACC.DATE.LIST<1>
                    FILE.ID = ARR.ID:"-":"ACCOUNT":"-":FINAL.DATE
                    CALL F.READ(FN.AA.ARR.ACCOUNT,FILE.ID,R.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT,ACC.ERR)
                    R.AA.ARR.ACCOUNT<AA.AC.ALT.ID,4,1> = Y.ALT.ID
                    WRITE R.AA.ARR.ACCOUNT TO F.AA.ARR.ACCOUNT,FILE.ID

                    Y.OUT.MSG = 'SUCCESS'
                END
            END ELSE
                Y.OUT.MSG = 'NOT AN ARRANGEMENT'
            END
            DELIM = '|'
            FINAL.ARRAY = ''
            FINAL.ARRAY<-1> = ARR.ID:DELIM:Y.OUT.MSG
            WRITE FINAL.ARRAY TO F.TEMP.FILE.PATH,ARR.ID

        END

    REPEAT

RETURN
END
