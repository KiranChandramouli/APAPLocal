* @ValidationCode : MjoyMjEyMzI0NTpDcDEyNTI6MTY4MjMyMDM5NjY2Njphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 12:43:16
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
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  IF STATEMENT MODIFIED , $INCLUDEto $INSERT, I to I.VAR , J to J.VAR
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ACCT.ECB.BAL.FROM.ACTIVITY

* R12 ==> Updates ECB fields 68-72 as well  ; Comment the para for lower releases.

* This routine will rebuild account balance fields 23 - 27
* Relies on last ACCT.ACTIVITY & DATES.EXPOSURE
* Make sure there are no Unauthorised transactions for account before rebuild

    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.DATES
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.ACCOUNT.PARAMETER ;*R22 AUTO CODE CONVERSION

* RTN.TIME=OCONV(TIME(),"MTS")
* EXECUTE "COMO ON ACCT.ECB.BAL.FROM.ACTIVITY_":RTN.TIME

    SEL.LIST = '' ; NO.OF.REC = '' ; ERR = ''; CMD=''

    GOSUB INITIALISE

* Save the problematic Account IDs in &SAVEDLISTS& directory under the name PROB.ACCOUNT.IDS
*    CMD= "GET.LIST PROB.ACCOUNT.IDS"
*    CALL EB.READLIST(CMD,SEL.LIST,'',CNT1,ER)
    OPEN "&SAVEDLISTS&" TO F.BP ELSE PRINT 'Unable to open SAVEDLIST'
    READ SEL.LIST FROM F.BP,'PROB.ACCT.IDS' ELSE PRINT 'Savedlist not input'
    IF SEL.LIST THEN
        LOOP
            REMOVE ACC.ID FROM SEL.LIST SETTING POS
        WHILE ACC.ID:POS
            R.ACCT=''; ACC.ID = TRIM(ACC.ID)
            READ R.ACCT FROM FV.ACCOUNT, ACC.ID ELSE
                PRINT "Account ":ACC.ID:" does not exist, cannot rebuild balance"
                GOTO PROGRAM.END
            END
            GOSUB INIT.VARS
            GOSUB PROCESS
PROGRAM.END:
        REPEAT
    END

* EXECUTE "COMO OFF ACCT.ECB.BAL.FROM.ACTIVITY_":RTN.TIME
* PRINT "COMO saved as *** ACCT.ECB.BAL.FROM.ACTIVITY_":RTN.TIME:" ***"
    SLEEP 2
RETURN

************
INITIALISE:
************

    FN.ACCOUNT="F.ACCOUNT"
    FV.ACCOUNT=""
    CALL OPF(FN.ACCOUNT,FV.ACCOUNT)

    FN.STMT.ENTRY="F.STMT.ENTRY"
    FV.STMT.ENTRY=""
    CALL OPF(FN.STMT.ENTRY,FV.STMT.ENTRY)

    FN.ECB='F.EB.CONTRACT.BALANCES'
    FV.ECB=''
    CALL OPF(FN.ECB,FV.ECB)

    FN.ACCOUNT.PARAMETER="F.ACCOUNT.PARAMETER"
    FV.ACCOUNT.PARAMETER=""
    CALL OPF(FN.ACCOUNT.PARAMETER,FV.ACCOUNT.PARAMETER)

    FN.DATE.EXPOSURE="F.DATE.EXPOSURE"
    FV.DATE.EXPOSURE=""
    CALL OPF(FN.DATE.EXPOSURE,FV.DATE.EXPOSURE)

RETURN

************
INIT.VARS:
************

    BALANCE.DATE1=""; BALANCE.DATE2=""; YBALANCE1=""; YBALANCE2=""
    CR.MVMT1=""; CR.MVMT2=""; DR.MVMT1=""; DR.MVMT2=""; ERR1=""; ERR2=""
    OPN.ACT.BAL=""; OPN.CLR.BAL=""; ONL.ACT.BAL=""; ONL.CLR.BAL=""; WORK.BAL=""
    EXP.CNT=""; J.VAR=""; R.ACCT=""; WB.DIFF=0 ;*R22 AUTO CODE CONVERSION

RETURN


*********
PROCESS:
*********

    READU R.ACCT FROM FV.ACCOUNT, ACC.ID THEN

***** Obtain open and online balance from ACCT.ACTIVITY using core routine*****

        BALANCE.DATE1 = R.DATES(EB.DAT.PERIOD.END)
        BALANCE.DATE2 = R.DATES(EB.DAT.LAST.PERIOD.END)

        CALL EB.GET.ACCT.BALANCE(ACC.ID, R.ACCT, "BOOKING", BALANCE.DATE1,"", YBALANCE1, CR.MVMT1, DR.MVMT1, ERR1)      ;* Get online actual balance
        CALL EB.GET.ACCT.BALANCE(ACC.ID, R.ACCT, "BOOKING", BALANCE.DATE2,"", YBALANCE2, CR.MVMT2, DR.MVMT2, ERR2)      ;* Get open actual balance

        OPN.ACT.BAL = YBALANCE2
        OPN.CLR.BAL = YBALANCE2
        ONL.ACT.BAL = YBALANCE1
        ONL.CLR.BAL = YBALANCE1
        WORK.BAL = YBALANCE1

***** Build cleared balance based on DATES.EXPOSURE *****
        READU R.ECB FROM FV.ECB, ACC.ID ELSE
            PRINT 'ECB missing :':ACC.ID
            RELEASE FN.ECB,ACC.ID
        END

        IF R.ECB<ECB.NEXT.EXP.DATE> NE "" THEN
            EXP.CNT = DCOUNT(R.ECB<ECB.EXPOSURE.DATES>,@VM)
            FOR J.VAR = 1 TO EXP.CNT ;*R22 AUTO CODE CONVERSION
                I.VAR=""; CNT=""; EXP.DATE=""; EXP.ID=""; R.EXPOSURE=""
                EXP.DATE = R.ECB<ECB.EXPOSURE.DATES,J.VAR>
                EXP.ID = ACC.ID:"-":EXP.DATE
                READ R.EXPOSURE FROM FV.DATE.EXPOSURE, EXP.ID ELSE R.EXPOSURE=""
                CNT = DCOUNT(R.EXPOSURE,@FM)
                FOR I.VAR = 1 TO CNT ;*R22 AUTO CODE CONVERSION
                    R.ENTRY=""
                    READ R.ENTRY FROM FV.STMT.ENTRY, R.EXPOSURE<I.VAR> ELSE R.ENTRY=""
                    IF R.ENTRY<AC.STE.AMOUNT.FCY> THEN
                        IF R.ENTRY<AC.STE.BOOKING.DATE> NE TODAY THEN
                            OPN.CLR.BAL -= R.ENTRY<AC.STE.AMOUNT.FCY>
                        END ;*R22 AUTO CODE CONVERSION
                        ONL.CLR.BAL -= R.ENTRY<AC.STE.AMOUNT.FCY>
                        WORK.BAL -= R.ENTRY<AC.STE.AMOUNT.FCY>
                    END ELSE
                        IF R.ENTRY<AC.STE.BOOKING.DATE> NE TODAY THEN
                            OPN.CLR.BAL -= R.ENTRY<AC.STE.AMOUNT.LCY>
                        END ;*R22 AUTO CODE CONVERSION
                        ONL.CLR.BAL -= R.ENTRY<AC.STE.AMOUNT.LCY>
                        WORK.BAL -= R.ENTRY<AC.STE.AMOUNT.LCY>
                    END
                NEXT I.VAR
            NEXT J.VAR
        END

***** Maintain the difference in Working balance, due to ENTRY.HOLD *****

        WB.DIFF = R.ACCT<AC.ONLINE.CLEARED.BAL> - R.ACCT<AC.WORKING.BALANCE>
        IF WB.DIFF GT 0 THEN  ;* INAU debit is valid to update WORK.BAL not credit
            WORK.BAL -= WB.DIFF
        END

        PRINT "Account##":ACC.ID:"##Before rebuild##":R.ACCT<AC.OPEN.ACTUAL.BAL>:"##":R.ACCT<AC.OPEN.CLEARED.BAL>:"##":R.ACCT<AC.ONLINE.ACTUAL.BAL>:"##":R.ACCT<AC.ONLINE.CLEARED.BAL>:"##":R.ACCT<AC.WORKING.BALANCE>

        READ R.ACCT.PARAM FROM FV.ACCOUNT.PARAMETER, "SYSTEM" ELSE
            PRINT "Account parameter cannot able to read"
*        GOTO PROGRAM.END
        END

        IF R.ACCT.PARAM<AC.PAR.ENT.TODAY.UPDATE>[1,1] EQ "N" THEN
            R.ACCT<AC.OPEN.ACTUAL.BAL> = ''
            R.ACCT<AC.OPEN.CLEARED.BAL> = ''
        END ELSE
            R.ACCT<AC.OPEN.ACTUAL.BAL> = OPN.ACT.BAL
            R.ACCT<AC.OPEN.CLEARED.BAL> = OPN.CLR.BAL
        END
        R.ACCT<AC.ONLINE.ACTUAL.BAL> = ONL.ACT.BAL
        R.ACCT<AC.ONLINE.CLEARED.BAL> = ONL.CLR.BAL
        R.ACCT<AC.WORKING.BALANCE> = WORK.BAL
        PRINT "Account##":ACC.ID:"##After rebuild##":OPN.ACT.BAL:"##":OPN.CLR.BAL:"##":ONL.ACT.BAL:"##":ONL.CLR.BAL:"##":WORK.BAL

* Comment the below line, if the ECB is not having AC balance fields R12 onwards only.
* GOSUB UPD.ECB
        WRITE R.ACCT TO FV.ACCOUNT, ACC.ID
*
    END
    RELEASE FV.ACCOUNT, ACC.ID

RETURN


UPD.ECB:
********

    IF R.ACCT.PARAM<AC.PAR.ENT.TODAY.UPDATE>[1,1] EQ "N" THEN
        R.ECB<ECB.OPEN.ACTUAL.BAL> = ''
        R.ECB<ECB.OPEN.CLEARED.BAL> = ''
    END ELSE
        R.ECB<ECB.OPEN.ACTUAL.BAL> = OPN.ACT.BAL
        R.ECB<ECB.OPEN.CLEARED.BAL> = OPN.CLR.BAL
    END
    R.ECB<ECB.ONLINE.ACTUAL.BAL> = ONL.ACT.BAL
    R.ECB<ECB.ONLINE.CLEARED.BAL> = ONL.CLR.BAL
    R.ECB<ECB.WORKING.BALANCE> = WORK.BAL
    WRITE R.ECB TO FV.ECB, ACC.ID
    PRINT 'ECB balance updated :':ACC.ID
    RELEASE FV.ECB, ACC.ID

RETURN
END
