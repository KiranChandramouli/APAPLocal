* @ValidationCode : Mjo2OTk4NzE3OTA6Q3AxMjUyOjE2ODIwNzAxMzExNTk6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:12:11
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
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   F.READ to CACHE.READ
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ATM.PREV(ATMID.UNIQUE.ID,OUTGOING)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.ATM.BRANCH
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.CURRENCY
    $INSERT I_F.DATES
*

    GOSUB INITIALISE
    GOSUB GET.TXN.BRANCH
    GOSUB CHK.ORIGINAL.TXN

RETURN  ;*Main return

INITIALISE:
*--------------*
    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)
*
    FN.COMPANY = 'F.COMPANY'
    CALL OPF(FN.COMPANY,F.COMPANY)
*
    FN.ATM.ISO.BRANCH = 'F.ATM.BRANCH'
    CALL OPF(FN.ATM.ISO.BRANCH,F.ATM.ISO.BRANCH)
*
    FN.CURRENCY = 'F.CURRENCY'
    CALL OPF(FN.CURRENCY,F.CURRENCY)


RETURN  ;*From initialise




GET.TXN.BRANCH:
*------------------------*

*Start of modification for PACS00054730-----------------------------------------------
    ATM.BR=ATMID.UNIQUE.ID
*End of modification----------------------------------------------------------------
    ATM.BR=TRIM(ATM.BR,"0","L")

    CALL F.READ(FN.ATM.ISO.BRANCH,ATM.BR,R.ATM.BRANCH,F.ATM.ISO.BRANCH,ER.ATM.BRANCH)
    IF R.ATM.BRANCH THEN

    END ELSE
        CALL F.READ(FN.ATM.ISO.BRANCH,'HBDF01',R.ATM.BRANCH,F.ATM.ISO.BRANCH,ER.ATM.BRANCH)
    END

    Y.ACCT.COMP.CDE = R.ATM.BRANCH<ATM.BR.COMPANY.CODE>
    CALL CACHE.READ(FN.COMPANY, Y.ACCT.COMP.CDE, REC.COMPANY, ER.COMPANY) ;*R22 AUTO CODE CONVERSION
    MNEMONIC = REC.COMPANY<EB.COM.MNEMONIC>

    FN.FUNDS.TRANSFER = 'F':MNEMONIC:'.FUNDS.TRANSFER'
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)


RETURN  ;*From GET.TXN.BRANCH
*---------------------------------------------------------------------*
CHK.ORIGINAL.TXN:
*--------------*
*added by liri


    UNIQUE.ID = ATMID.UNIQUE.ID[9,25]
    AMT.ID = ATMID.UNIQUE.ID[34,12]
    CALL CACHE.READ(FN.CURRENCY, LCCY, R.CURRENCY, ERR.CURR)
    CURR.DEC = R.CURRENCY<EB.CUR.NO.OF.DECIMALS>

    LEN.AMT.IN = LEN(AMT.ID)
    AMT.OUT = AMT.ID[1,LEN.AMT.IN-CURR.DEC]
    AMT.OUT:='.'
    AMT.OUT := AMT.ID[LEN.AMT.IN-1,CURR.DEC]


    CALL F.READ(FN.ATM.REVERSAL,UNIQUE.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ER.ATM.REVERSAL)

*if we dont get 220 in 90th field for 220 msgs
*/by liri
    IF NOT(R.ATM.REVERSAL) THEN
        LEN.UNIQUE.ID = LEN(UNIQUE.ID)
        UNIQUE.ID = 220:UNIQUE.ID[4,LEN.UNIQUE.ID-3]

        CALL F.READ(FN.ATM.REVERSAL,UNIQUE.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ER.ATM.REVERSAL)
    END
    GOSUB CALC.PART

RETURN

*****************
CALC.PART:
*****************

    IF R.ATM.REVERSAL THEN
        TXN.AMT = R.ATM.REVERSAL<AT.REV.TXN.AMOUNT>
        TEST.FT = R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
        TEST.VAR = R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>[1,1]
        JUL.DATE = R.DATES(EB.DAT.JULIAN.DATE)
        CHECK.JUL = JUL.DATE[3,5]
        LEN.FT = LEN(TEST.FT)
        CHECK.FT1 = TEST.FT[1,LEN.FT-5]
        CHECK.FT2 = LEN(CHECK.FT1)

        CHECK.FT = CHECK.FT1[CHECK.FT2-4,5]


*/check whether the FT julian date and julian date in DATES r same
* this is for solving the error "HISTORY RECORD MISSING"
        IF CHECK.JUL EQ CHECK.FT THEN

            IF R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>[1,1] NE 'R' THEN
                IF R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>[1,1] NE 'W' THEN
                    FT.TXN.REF = R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
                    OUTGOING.FUNCTION = 'R'
                END ELSE
                    OUTGOING.FUNCTION = 'S'
                END
*added by liril for forcepost dup reversal
            END ELSE
                OUTGOING = 'gOFSUtilName:1:1=FUNDS.TRANSFER,REV.DUP'
                OUTGOING:= '$':'gOFSFunction:1:1=I'
                FT.ID = ""
                OUTGOING:= '$':'gOFSId:1:1=':FT.ID:'$'
            END
        END ELSE
            GOSUB FORM.OUTGOING1
            RETURN
        END

    END ELSE
*added by liril
        OUTGOING = 'gOFSUtilName:1:1=FUNDS.TRANSFER,REV.DUP'
        OUTGOING:= '$':'gOFSFunction:1:1=I'
        FT.ID = ""
        OUTGOING:= '$':'gOFSId:1:1=':FT.ID:'$'
    END
*end of addition

    BEGIN CASE

        CASE AMT.OUT EQ TXN.AMT AND TEST.VAR NE 'R'
            GOSUB FORM.OUTGOING
        CASE AMT.OUT LT TXN.AMT AND TEST.VAR NE 'R'
            GOSUB FORM.OUTGOING1
    END CASE


RETURN  ;*From chk.original txn

*----------------------------------------------------------------------*

FORM.OUTGOING:
*-------------*
    OUTGOING = ''
    OUTGOING = 'gOFSUtilName:1:1=FUNDS.TRANSFER,REV.POS'
    OUTGOING:= '$':'gOFSFunction:1:1=R'
    FT.ID = R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
    OUTGOING := '$':'gOFSId:1:1=':FT.ID:'$'


RETURN  ;*From FORM.OUTGOING

*------------------------------------------------------------------------*

FORM.OUTGOING1:

    OUTGOING = ''
    OUTGOING = 'gOFSUtilName:1:1=FUNDS.TRANSFER,REV.POS'
    OUTGOING:= '$':'gOFSFunction:1:1=I'
*added by liril
    FT.ID = ""
    OUTGOING := '$':'gOFSId:1:1=':FT.ID:'$'
RETURN
*-------------------------------------------------------------------------*
