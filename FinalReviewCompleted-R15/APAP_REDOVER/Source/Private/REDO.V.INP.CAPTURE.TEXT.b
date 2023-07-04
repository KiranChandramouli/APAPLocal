* @ValidationCode : MjotMTQ5MzkyMjQ3NTpDcDEyNTI6MTY4MjQxMjM0ODAwNzpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CAPTURE.TEXT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.V.VAL.CAPTURE.TEXT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the reasons from the customer while
*                   closing the ACCOUNT using ACCOUNT.CLOSURE and AZ.ACCOUNT application
*LINKED WITH       :
*
* Revision History:
*------------------
* Date          who                  Reference       Description
* 27/02/2013    Vignesh Kumaar M R   PACS00251876    Suppress ACL.ENTRIES.POSTED.TODAY override
* 06/03/2013    Vignesh Kumaar M R   PACS00253690    CHECK FOR CREDIT ACCOUNT - DECEASED
* 11/03/2013    Vignesh Kumaar M R   PACS00253590    Pay Int amount to the Nominated Account
* 26/04/2013    Arundev KR           PACS00266553    override should display for Account closure
* ----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM, I TO I.VAR
*11-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_GTS.COMMON
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End


    GOSUB OPEN.FILES
    GOSUB INIT
    GOSUB PROCESS
    GOSUB PGM.END
RETURN
*-----------
OPEN.FILES:
*-----------
    FN.ACCOUNT.CLOSURE='F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE=''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*------
INIT:
*------

    LOC.REF.APPLICATION="ACCOUNT.CLOSURE":@FM:"AZ.ACCOUNT":@FM:"ACCOUNT"
    LOC.REF.FIELDS="L.AC.CAN.REASON":@VM:"L.AC.OTH.REASON":@VM:"L.CLOSE.MODE":@FM:"L.AC.CAN.REASON":@VM:"L.AC.OTH.REASON":@VM:"L.TYPE.INT.PAY":@FM:"L.AC.STATUS2"
    LOC.REF.POS=''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    LOC.REF.AC.REASON=LOC.REF.POS<1,1>
    LOC.REF.AC.OTHER=LOC.REF.POS<1,2>
    LOC.REF.CLOSE.MODE = LOC.REF.POS<1,3> ;*PACS00266553
    LOC.REF.AZ.REASON=LOC.REF.POS<2,1>
    LOC.REF.AZ.OTHER=LOC.REF.POS<2,2>
    GET.INT.TYPE = LOC.REF.POS<2,3>
    GET.ACCT.STATUS.POS = LOC.REF.POS<3,1>

RETURN
*---------
PROCESS:
*----------

    APPLN=APPLICATION

    IF APPLN EQ "ACCOUNT.CLOSURE" THEN
        GOSUB CHK.WORKING.BALANCE
        GOSUB SUPPRESS.OVRIDE
        GOSUB CHECK.ACCT.CLOSE
    END ELSE
        GOSUB CHECK.AZ
    END
RETURN
*-----------------------------------------------------------------------
CHK.WORKING.BALANCE:
*-----------------------------------------------------------------------
    VAR.ID = ID.NEW
    CALL F.READ(FN.ACCOUNT,VAR.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    R.ECB= '' ; ECB.ERR= '' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",VAR.ID,R.ECB,ECB.ERR)
*VAR.WORK.BAL = R.ACCOUNT<AC.WORKING.BALANCE>
    VAR.WORK.BAL = R.ECB<ECB.WORKING.BALANCE>;*Tus End

    IF VAR.WORK.BAL AND VAR.WORK.BAL LT '0' THEN
        AF=AC.ACL.ONLINE.ACTUAL.BAL
        ETEXT="EB-ACCT.CLOSE.NEGATIVE"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END

    VAR.TOT.ACC.AMT =  R.NEW(AC.ACL.TOTAL.ACC.AMT)
    IF VAR.TOT.ACC.AMT AND VAR.TOT.ACC.AMT LT '0' THEN
        AF=AC.ACL.TOTAL.ACC.AMT
        ETEXT="EB-ACCT.CLOSE.NEGATIVE"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END

RETURN
*-----------------------------------------------------------------------
SUPPRESS.OVRIDE:
*-----------------------------------------------------------------------
    Y.STORED.OVERRIDES = R.NEW(AC.ACL.OVERRIDE)
*IF V$FUNCTION EQ 'I' AND OFS$OPERATION EQ 'PROCESS' AND NOT(OFS.VAL.ONLY) THEN
    IF V$FUNCTION EQ 'I' AND OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB SUPPRESS.OVRIDE.PROCESS
    END

RETURN


*-----------------------------------------------------------------------
SUPPRESS.OVRIDE.PROCESS:
*-----------------------------------------------------------------------

    POS.FM.REP = ''
    POS.VM.REP = ''
    POS.VM.OVER = ''
    POS.FM.OVER = ''
*PACS00266553-start
    AC.CLOSE.MODE = R.NEW(AC.ACL.LOCAL.REF)<1,LOC.REF.CLOSE.MODE>
    IF AC.CLOSE.MODE EQ 'TELLER' THEN
*PACS00266553-end
        FINDSTR 'ACL.ACCT.NOT.BELONG.CUST' IN Y.STORED.OVERRIDES SETTING POS.FM.REP,POS.VM.REP THEN
            DEL R.NEW(AC.ACL.OVERRIDE)<POS.FM.REP,POS.VM.REP>
            FINDSTR 'NO PERTENECE AL CLIENTE' IN OFS$OVERRIDES SETTING POS.FM.OVER,POS.VM.OVER THEN
                OFS$OVERRIDES<2,POS.VM.OVER> = "YES"
            END
        END
    END

* Fix for PACS00251876 [Suppress ACL.ENTRIES.POSTED.TODAY override]

    POS.FM.REP = ''
    POS.VM.REP = ''
    POS.VM.OVER = ''
    POS.FM.OVER = ''
    Y.STORED.OVERRIDES = R.NEW(AC.ACL.OVERRIDE)
    FINDSTR 'ACL.CASH.TYPE.CLOSURE' IN Y.STORED.OVERRIDES SETTING POS.FM.REP,POS.VM.REP THEN
        DEL R.NEW(AC.ACL.OVERRIDE)<POS.FM.REP,POS.VM.REP>
        FINDSTR 'CUENTA CERRADA EN EFECTIVO' IN OFS$OVERRIDES SETTING POS.FM.OVER,POS.VM.OVER THEN
            OFS$OVERRIDES<2,POS.VM.OVER> = "YES"
        END
    END

* End of Fix

    POS.FM.REP = ''
    POS.VM.REP = ''
    POS.VM.OVER = ''
    POS.FM.OVER = ''
    Y.STORED.OVERRIDES = R.NEW(AC.ACL.OVERRIDE)
    FINDSTR 'ACL.AMOUNT.LOCKED' IN Y.STORED.OVERRIDES SETTING POS.FM.REP,POS.VM.REP THEN
        DEL R.NEW(AC.ACL.OVERRIDE)<POS.FM.REP,POS.VM.REP>
        FINDSTR 'BLOQUEDO PARA LA CUENTA' IN OFS$OVERRIDES SETTING POS.FM.OVER,POS.VM.OVER THEN
            OFS$OVERRIDES<2,POS.VM.OVER> = "YES"
        END
        TEXT='ACCT.BAL.LT.LOCKED':@FM:ID.NEW
        YCURR.NO = DCOUNT(R.NEW(AC.ACL.OVERRIDE),@VM)+1
        CALL STORE.OVERRIDE(YCURR.NO)

    END
RETURN
*-----------------
CHECK.ACCT.CLOSE:
*-----------------
    CHECKER="Others"

    LOC.VAR=R.NEW(AC.ACL.LOCAL.REF)<1,LOC.REF.AC.REASON>
    VCOUNT=DCOUNT(LOC.VAR,@SM)
    I.VAR = 1
    LOOP
    WHILE I.VAR LE VCOUNT
        LOC.VAR.REASON=R.NEW(AC.ACL.LOCAL.REF)<1,LOC.REF.AZ.REASON,I.VAR>
        LOC.VAR.OTHERS=R.NEW(AC.ACL.LOCAL.REF)<1,LOC.REF.AC.OTHER,I.VAR>

        IF LOC.VAR.REASON EQ CHECKER AND LOC.VAR.OTHERS EQ '' THEN
            AF=AC.ACL.LOCAL.REF
            AV=LOC.REF.AC.OTHER
            AS=I.VAR
            ETEXT="EB-MAND.FOR.OTHERS"
            CALL STORE.END.ERROR
            GOSUB PGM.END
        END
        I.VAR += 1
    REPEAT

RETURN
*-----------------
CHECK.AZ:
*----------------
    IF APPLN EQ "AZ.ACCOUNT" THEN
        CHECKER="Others"
        LOC.VAR=R.NEW(AZ.LOCAL.REF)<1,LOC.REF.AZ.REASON>
        VCOUNT=DCOUNT(LOC.VAR,@SM)
        I.VAR = 1
        LOOP
        WHILE I.VAR LE VCOUNT
            LOC.VAR.REASON=R.NEW(AZ.LOCAL.REF)<1,LOC.REF.AZ.REASON,I.VAR>
            LOC.VAR.OTHERS=R.NEW(AZ.LOCAL.REF)<1,LOC.REF.AZ.OTHER,I.VAR>

            IF LOC.VAR.REASON EQ CHECKER AND LOC.VAR.OTHERS EQ '' THEN
                AF=AZ.LOCAL.REF
                AV=LOC.REF.AZ.OTHER
                AS=I.VAR
                ETEXT="EB-MAND.FOR.OTHERS"
                CALL STORE.END.ERROR
                GOSUB PGM.END
            END
            I.VAR += 1
        REPEAT

* Fix for PACS00253690 [CHECK FOR CREDIT ACCOUNT - DECEASED]

        GET.NOM.ACCT = R.NEW(AZ.NOMINATED.ACCOUNT)
        R.ACCOUNT = ''
        CALL F.READ(FN.ACCOUNT,GET.NOM.ACCT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
        GET.ACCT.STATUS = R.ACCOUNT<AC.LOCAL.REF,GET.ACCT.STATUS.POS>

        IF GET.ACCT.STATUS EQ 'DECEASED' THEN
            AF = AZ.NOMINATED.ACCOUNT
            ETEXT = "EB-REDO.AC.DECEASED"
            CALL STORE.END.ERROR
            GOSUB PGM.END
        END

* End of Fix

* Fix for PACS00253590 [Pay Int amount to the Nominated Account]

        IF R.NEW(AZ.NOMINATED.ACCOUNT) NE '' AND R.NEW(AZ.LOCAL.REF)<1,GET.INT.TYPE> NE 'Reinvested' THEN

            R.NEW(AZ.INTEREST.LIQU.ACCT) = R.NEW(AZ.NOMINATED.ACCOUNT)

            R.ACCOUNT = ''
            ACCOUNT.ERR = ''
            CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

            IF R.ACCOUNT AND R.ACCOUNT<AC.INTEREST.LIQU.ACCT> NE GET.NOM.ACCT THEN
                R.ACCOUNT<AC.INTEREST.LIQU.ACCT> = R.NEW(AZ.NOMINATED.ACCOUNT)
                CALL F.WRITE(FN.ACCOUNT,ID.NEW,R.ACCOUNT)
            END

        END

* End of Fix

    END

RETURN
*-----------------
PGM.END:
*-------------------
END
