* @ValidationCode : MjotMTI5OTU3NjQ1MDpDcDEyNTI6MTY4MjMyMDU2MjQxNzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 12:46:02
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
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   IF STATEMENT MODIFIED ,I to I.VAR , XtoX.VAR,K to K.VAR
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ASP.REBUILD(ACC.ID)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.STATEMENT

    GOSUB INITIALISATION
    GOSUB OPENFILE

*ACC.ID = ? ;* problematic account
    MIN.DATE = '' ;* date since rebuild. can be left null for full rebuild

    Y.ACCOUNT.NUMBER = ACC.ID
    GOSUB PROCESS

RETURN

***************
INITIALISATION:
***************

    FN.STM = "F.STMT.ENTRY"; F.STM = ""
    FN.ASTM = "F.ACCT.STMT.PRINT"; F.ASTM = ""
    FN.SP = "F.STMT.PRINTED"; F.SP = ""
    FN.ACCOUNT = "F.ACCOUNT"; F.ACCOUNT = ""
    FN.ACC.CLOSED = "F.ACCOUNT.CLOSED"; F.ACC.CLOSED = ""
    FN.ACC.STMT = "F.ACCOUNT.STATEMENT"; F.ACC.STMT = ""

    F.SL = '&SAVEDLISTS&'; FN.SL = ''
    OPEN F.SL TO FN.SL ELSE NULL

RETURN

*********
OPENFILE:
*********

    CALL OPF(FN.ASTM, F.ASTM)
    CALL OPF(FN.STM, F.STM)
    CALL OPF(FN.SP, F.SP)
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
    CALL OPF(FN.ACC.CLOSED, F.ACC.CLOSED)
    CALL OPF(FN.ACC.STMT, F.ACC.STMT)

RETURN

********
PROCESS:
********

    R.ACCT = ""
    READU R.ACCT FROM F.ACCOUNT, Y.ACCOUNT.NUMBER ELSE
        CRT "Account ":Y.ACCOUNT.NUMBER:" does not exist"
        R.ACCT = ''
        RELEASE F.ACCOUNT, Y.ACCOUNT.NUMBER
        RETURN
    END

    IF R.ACCT THEN
        DELETE F.ACC.CLOSED, Y.ACCOUNT.NUMBER
    END

    GOSUB ASP.REBUILD

    RELEASE F.ACCOUNT, Y.ACCOUNT.NUMBER

RETURN

************
ASP.REBUILD:
************

    ASP.ID = Y.ACCOUNT.NUMBER

    ASP.REC = ''; R.ACC.STMT = ''; FWD.BAL = 0; APOS = ''
    READ R.ACC.STMT FROM F.ACC.STMT, ASP.ID ELSE R.ACC.STMT = ''
    READ ASP.REC FROM F.ASTM, ASP.ID ELSE ASP.REC = ''
    FQU.DATE = R.ACC.STMT<AC.STA.STMT.FQU.1,1>[1,8]
    FQU.TYPE = R.ACC.STMT<AC.STA.STMT.FQU.1,1>[9,5]

    STMT.DATES = ''; STMT.BALS = ''; NEXT.DATE.NO = ''
    STMT.DATES = FIELDS(ASP.REC, '/', 1, 1)
    STMT.BALS = FIELDS(ASP.REC, '/', 2, 1)
    NEXT.DATE.NO = DCOUNT(STMT.DATES, @FM)

    IF MIN.DATE THEN
        LOCATE MIN.DATE IN STMT.DATES<1> BY 'AR' SETTING APOS ELSE NULL
    END ELSE
        APOS = 1
    END
    IF APOS GT NEXT.DATE.NO THEN
        APOS = NEXT.DATE.NO
    END ;*R22 AUOD CODE CONVERSION
    NEXT.FREQ.BAL = STMT.BALS<APOS> + 0

    FOR I.VAR = APOS TO NEXT.DATE.NO
        SP.DATE = STMT.DATES<I.VAR> ;*R22 AUOD CODE CONVERSION
        IF SP.DATE GE TODAY THEN
            GOTO 100         ;* Do not calculate closing bal for the frequency scheduled for printing
        END ;*R22 AUOD CODE CONVERSION
        SP.ID = ASP.ID:"-":SP.DATE
        SP.REC = ""; CNT.STMT = ""; STMT.BAL = 0; STMT.ID = ""
        READ SP.REC FROM F.SP, SP.ID ELSE SP.REC = ''
        CNT.STMT = DCOUNT(SP.REC, @FM)
        FOR X.VAR = 1 TO CNT.STMT ;*R22 AUOD CODE CONVERSION
            STMT.ID = SP.REC<X.VAR>
            R.STMT.ENTRY=""
            READ R.STMT.ENTRY FROM F.STM, STMT.ID ELSE R.STMT.ENTRY = ''
            IF R.STMT.ENTRY<AC.STE.CURRENCY> NE LCCY THEN
                STMT.BAL += R.STMT.ENTRY<AC.STE.AMOUNT.FCY>
            END ELSE
                STMT.BAL += R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
            END
        NEXT X.VAR

        OP.BAL = 0
        IF STMT.BALS<I.VAR> THEN
            OP.BAL = STMT.BALS<I.VAR>
        END
        NEXT.FREQ = '' ; NEXT.FREQ.BAL = ''
        NEXT.FREQ.BAL = OP.BAL + STMT.BAL
        NEXT.FREQ = STMT.DATES<I.VAR+1>
        IF NEXT.FREQ EQ '' THEN ;*R22 AUOD CODE CONVERSION
            IF R.ACC.STMT THEN
                R.ACC.STMT<AC.STA.FQU1.LAST.DATE> = STMT.DATES<I.VAR>
                R.ACC.STMT<AC.STA.FQU1.LAST.BALANCE> = NEXT.FREQ.BAL
            END
        END ELSE
            IF NEXT.FREQ LT TODAY THEN
                STMT.BALS<I.VAR+1> = NEXT.FREQ.BAL
            END ELSE
                STMT.BALS<I.VAR+1> = NEXT.FREQ.BAL
                IF R.ACC.STMT THEN
                    R.ACC.STMT<AC.STA.FQU1.LAST.DATE> = STMT.DATES<I.VAR>
                    R.ACC.STMT<AC.STA.FQU1.LAST.BALANCE> = NEXT.FREQ.BAL
                END
            END
        END
100:
        IF SP.DATE GE TODAY THEN
            SP.REC=""; K.VAR=""; SP.ID=""; CNT.FWD=""
            SP.ID = ASP.ID:"-":SP.DATE
            READ SP.REC FROM F.SP, SP.ID ELSE SP.REC = ''
            CNT.FWD = DCOUNT(SP.REC,@FM)
            FOR K.VAR = 1 TO CNT.FWD
                R.STMT.ENTRY=""; STMT.ID=""
                STMT.ID = SP.REC<K.VAR>
                READ R.STMT.ENTRY FROM F.STM,STMT.ID ELSE R.STMT.ENTRY = ''
                IF R.STMT.ENTRY<AC.STE.CURRENCY> NE LCCY THEN
                    FWD.BAL += R.STMT.ENTRY<AC.STE.AMOUNT.FCY>
                END ELSE
                    FWD.BAL += R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
                END
            NEXT K.VAR
        END
    NEXT I.VAR

    ACCT.BAL = R.ACCT<AC.ONLINE.ACTUAL.BAL>
    IF NOT(ACCT.BAL) THEN
        ACCT.BAL = 0
    END

    CRT Y.ACCOUNT.NUMBER:' Final SP balance = ':NEXT.FREQ.BAL:' next statement amount ':FWD.BAL:' Account balance = ':ACCT.BAL

    ARC.AMT = ACCT.BAL - NEXT.FREQ.BAL - FWD.BAL
    IF NOT(ARC.AMT) THEN
        ARC.AMT = 0
    END ;*R22 AUOD CODE CONVERSION
    IF ARC.AMT THEN
        R.ACC.STMT<AC.STA.FQU1.LAST.BALANCE> += ARC.AMT
        FOR I.VAR = APOS TO NEXT.DATE.NO
            STMT.BALS<I.VAR> += ARC.AMT
        NEXT I.VAR
    END

    IF ASP.REC THEN
        ASP.REC = SPLICE(STMT.DATES, "/", STMT.BALS)
        WRITE ASP.REC TO F.ASTM, ASP.ID
    END

    IF R.ACC.STMT THEN
        WRITE R.ACC.STMT TO F.ACC.STMT, ASP.ID
    END

RETURN

*************************************

END
