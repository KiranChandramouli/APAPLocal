* @ValidationCode : MjozNzg2NTgwODI6Q3AxMjUyOjE2OTg3NTA2NzM1MjE6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:13
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

$PACKAGE APAP.TFS




*-----------------------------------------------------------------------------
* <Rating>-352</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.INTERFACE.TT(MV.NO,OFS.BODY)
*
* Subroutine to Create OFS Message for FT, based on the value from
* R.NEW.
*
* MV.NO - The Multi Value Number or the Line Number to be processed
*
*=======================================================================
*
* Modification History:
*
* 09/22/04   - Sathish PS
*              New Development
*
* 03/25/05   - Sathish PS
*              Added code for passing on Denominations
*
* 08/03/05   - GP
*              Reading currency field  with multivalue
*
* 08/03/05   - Sathish PS
*              Read EXP.SCHEDULE with Multi value number
*
* 12/19/05   - Sesh V.S
*              In the FILL.DENOMINATIONS para, IF condition
*              R.NEW(TFS.CR.DEN.UNIT)<1,MV.NO,SV.COUNT> changed to check only for
*              NULL
*
* 22 NOV 2006 - Sesh V.S
*             - Code amended to take always the booking date.
*
* 29 AUG 07 - Sathish PS
*             Added a solid condition to determine if Reg CC Exposure needs to be used
*             And logic to export the TFS Exposure Details into TELLER.
*
* 04 SEP 07 - Sathish PS
*             Added logic to pick up exposure details only for netted.enttries (if
*             NET.ENTRY is Not NO)
*
* 18 SEP 07 - Sathish PS
*             Allow Account currency to be different from Transaction Currency
*
** 26 SEP 07 - Sathish PS
*             Dont pass Exposure details into EXP.SPT.DAT (thru local ref in TELLER)
*             if EXPOSURE.METHOD in TFS.PARAMETER is set to LOCK - for that, we need
*             to create AC.LOCKED.EVENTS.
*
* 27 May 08 - UPDATES DONE AND LEFT IN WORK.BP OF T24TR7 (RBTT TT)
*             Changes done by Sesh hasnt been updated in the pack or USPLATFORM.BP
*             The jshow was pointing to WORK.BP so this has been included in
*             the pack of 21st Aug 2008 by Geetha.
*
* 10/06/08 - Geetha Balaji
*            NSCU Gap 40
*            A new field was introduced, DEAL.RATE, in this Gap.
*            When a deal rate is given in one of the TFS line, default that to the
*            DEAL.RATE field in TELLER application.
*            We already have a version routine, V.DEFAULT.RATE, which would
*            default Buy/Sell rate depending on the Txn type. This is attached to the
*            TELLER,T24.FS version.
*            Henceforth, if the Deal rate is specified in TFS, then that would take
*            precedence over the version routine.
*            Clean-up of routine done to eliminate commented codes.
*
*08/05/09 -  Anitha.S
*            included Anti Money Laundering Gap for Multi Line Teller

*
*18/06/09 -  Anitha.S
*            multiline TFS not checking for stop payment HD0920984
*
*
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion            GLOBUS.BP File Removed,USPLATFORM.BP File Removed, CALL routine format modified, FM TO @FM, SM TO @SM
*=======================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    !  $INCLUDE I_T24.FS.COMMON
    $INCLUDE I_T24.FS.COMMON ;*R22 Manual Conversion

    $INSERT I_F.ACCOUNT

    $INSERT I_F.TELLER.TRANSACTION
    $INCLUDE I_F.CURRENCY ;*R22 Manual Conversion  - START
    $INCLUDE I_F.CATEGORY
    $INCLUDE I_F.T24.FUND.SERVICES
    $INCLUDE I_F.TFS.PARAMETER
    $INCLUDE I_F.TFS.TRANSACTION ;*R22 Manual Conversion - END
    
    
    
    GOSUB INIT
    GOSUB DETERMINE.CR.DR.SIDES
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*========================================================================
PROCESS:
    ! 18 SEP 07 - Sathish PS /s
    CR.AC = R.NEW(TFS.ACCOUNT.CR)<1,MV.NO>
    CALL F.READ(FN.AC,CR.AC,R.CR.AC,F.AC,ERR.AC)
    CR.AC.CCY = R.CR.AC<AC.CURRENCY>
    IF NOT(CR.AC.CCY) THEN
        IF NOT(NUM(CR.AC)) THEN
            CR.AC.CCY = CR.AC[1,3]
        END
    END

    DR.AC = R.NEW(TFS.ACCOUNT.DR)<1,MV.NO>
    CALL F.READ(FN.AC,DR.AC,R.DR.AC,F.AC,ERR.AC)
    DR.AC.CCY = R.DR.AC<AC.CURRENCY>
    IF NOT(DR.AC.CCY) THEN
        IF NOT(NUM(DR.AC)) THEN
            DR.AC.CCY = DR.AC[1,3]
        END
    END
    ! 18 SEP 07 - Sathish PS /e
    OFS.BODY = 'TRANSACTION.CODE:1:1=' : TFS$R.TFS.TXN(MV.NO)<TFS.TXN.INTERFACE.AS> :','
    ! 18 SEP 07 - Sathish PS /s
    !    OFS.BODY := 'CURRENCY.':DR.SIDE:':1:1=' : R.NEW(TFS.CURRENCY)<1,MV.NO> :','
    OFS.BODY := 'CURRENCY.':DR.SIDE:':1:1=' : DR.AC.CCY :','
    ! 18 SEP 07 - Sathish PS /e

    IF DR.SIDE NE 2 THEN
        ! 18 SEP 07 - Sathish PS /s
        !        IF R.NEW(TFS.CURRENCY)<1,MV.NO> EQ LCCY THEN
        IF DR.AC.CCY EQ LCCY THEN       ;* TESTING S/E
            ! 18 SEP 07 - Sathish PS /e
            !**          OFS.BODY := 'AMOUNT.LOCAL.':DR.SIDE:':1:1=' : R.NEW(TFS.AMOUNT)<1,MV.NO> :',' ; * 27 May 2008 /s
            OFS.BODY := 'AMOUNT.LOCAL.':DR.SIDE:':1:1=' : R.NEW(TFS.AMOUNT.LCY)<1,MV.NO> :','       ;* 27 May 2008 /e
        END ELSE
            OFS.BODY := 'AMOUNT.FCY.':DR.SIDE:':1:1=' : R.NEW(TFS.AMOUNT)<1,MV.NO> :','
            !OFS.BODY := 'AMOUNT.LOCAL.':DR.SIDE:':1:1=' : R.NEW(TFS.AMOUNT.LCY)<1,MV.NO> :',' ; * TESTING S/E
        END
    END
    OFS.BODY := 'ACCOUNT.':DR.SIDE:':1:1=' : R.NEW(TFS.ACCOUNT.DR)<1,MV.NO> :','
    OFS.BODY := 'VALUE.DATE.':DR.SIDE:':1:1=' : R.NEW(TFS.DR.VALUE.DATE)<1,MV.NO> :','

    ! 18 SEP 07 - Sathish PS /s
    !    OFS.BODY := 'CURRENCY.':CR.SIDE:':1:1=' : R.NEW(TFS.CURRENCY)<1,MV.NO> :','
    OFS.BODY := 'CURRENCY.':CR.SIDE:':1:1=' : CR.AC.CCY :','
    ! 18 SEP 07 - Sathish PS /e
    IF CR.SIDE NE 2 THEN
        ! 18 SEP 07 - Sathish PS /s
        !        IF R.NEW(TFS.CURRENCY)<1,MV.NO> EQ LCCY THEN
        IF CR.AC.CCY EQ LCCY THEN       ;* TESTING S/E
            ! 18 SEP 07 - Sathish PS /e
            !**            OFS.BODY := 'AMOUNT.LOCAL.':CR.SIDE:':1:1=' : R.NEW(TFS.AMOUNT)<1,MV.NO> :',' ; * 27 May 2008 /s
            OFS.BODY := 'AMOUNT.LOCAL.':CR.SIDE:':1:1=' : R.NEW(TFS.AMOUNT.LCY)<1,MV.NO> :','       ;* 27 May 2008 /e
        END ELSE
            OFS.BODY := 'AMOUNT.FCY.':CR.SIDE:':1:1=' : R.NEW(TFS.AMOUNT)<1,MV.NO> :','
            ! OFS.BODY := 'AMOUNT.LOCAL.':CR.SIDE:':1:1=' : R.NEW(TFS.AMOUNT.LCY)<1,MV.NO> :',' ; * TESTING S/E
        END
    END
    OFS.BODY := 'ACCOUNT.':CR.SIDE:':1:1=' : R.NEW(TFS.ACCOUNT.CR)<1,MV.NO> :','
    OFS.BODY := 'VALUE.DATE.':CR.SIDE:':1:1=' : R.NEW(TFS.CR.VALUE.DATE)<1,MV.NO> :','
    GOSUB CHECK.CREDIT.ACC.TYPE
    CR.EXPO.DATE = '' ; CR.EXPO.DATE = R.NEW(TFS.BOOKING.DATE)        ;* 22 NOV 2006 - Sesh V.S s/e
    IF CR.AC.CUS THEN
* To consider credit exposure date for a  future dated transaction - HD1053309 - S
        OFS.BODY := 'EXPOSURE.DATE.':CR.SIDE:':1:1=' : R.NEW(TFS.CR.EXP.DATE)<1,MV.NO> :','
*        OFS.BODY := 'EXPOSURE.DATE.':CR.SIDE:':1:1=' : CR.EXPO.DATE :','        ;* 22 NOV 2006 - Sesh V.S s/e
* HD1053309 - E
* Also, if EXP.SCHEDULE has been input then, try to populate Reg CC Local Ref Fields too

        GOSUB CHECK.FOR.REGCC
        IF REGCC THEN
            OFS.BODY := 'US.ITEMSORTCODE:1:1=' : R.NEW(TFS.EXP.SCHEDULE)<1,MV.NO> :','
            OFS.BODY := 'US.ITEM.AMOUNT:1:1=' : R.NEW(TFS.AMOUNT)<1,MV.NO> :','
            UES.ID = R.NEW(TFS.EXP.SCHEDULE)<1,MV.NO>
            CALL US.REGCC.GET.MAX.EXPOSURE(UES.ID,MAX.EXPOSURE)
            IF MAX.EXPOSURE THEN OFS.BODY := 'US.ITEM.EXPDATE:1:1=' : MAX.EXPOSURE :','
        END ELSE
            IF R.NEW(TFS.EXP.SCHEDULE) THEN GOSUB UPDATE.TFS.EXPOSURE.DETAILS   ;* 29 AUG 07 - Sathish PS s/e
        END
    END
* Gap 40 - 10/06/08 S
    IF R.NEW(TFS.DEAL.RATE)<1,MV.NO> THEN
        OFS.BODY := 'DEAL.RATE:1:1=':R.NEW(TFS.DEAL.RATE)<1,MV.NO>:','
    END
* Gap 40 - 10/06/08 E

    OFS.BODY := 'THEIR.REFERENCE:1:1=' : ID.NEW :','
    IF R.NEW(TFS.OUR.REFERENCE)<1,MV.NO> THEN
        OFS.BODY := 'OUR.REFERENCE:1:1=' : R.NEW(TFS.OUR.REFERENCE)<1,MV.NO> :','
    END

    IF R.NEW(TFS.NARRATIVE)<1,MV.NO> THEN
        OFS.BODY := 'NARRATIVE.':DR.SIDE:':1:1=' : R.NEW(TFS.NARRATIVE)<1,MV.NO> :','
        OFS.BODY := 'NARRATIVE.':CR.SIDE:':1:1=' : R.NEW(TFS.NARRATIVE)<1,MV.NO> :','
    END

*18/06/09 S Anitha multiline TFS not checking for stop payment HD0920984
*    IF R.NEW(TFS.CHQ.TYPE)<1,MV.NO> AND R.NEW(TFS.CHEQUE.NUMBER)<1,MV.NO> THEN
    IF R.NEW(TFS.CHQ.TYPE)<1,MV.NO> OR R.NEW(TFS.CHEQUE.NUMBER)<1,MV.NO> THEN
*18/06/09 E Anitha multiline TFS not checking for stop payment HD0920984

        OFS.BODY := 'CHEQUE.NUMBER:1:1=' : R.NEW(TFS.CHEQUE.NUMBER)<1,MV.NO> :','
        OFS.BODY := 'CHEQ.TYPE:1:1=' : R.NEW(TFS.CHQ.TYPE)<1,MV.NO> :','
    END

    IF R.NEW(TFS.CHG.AMT)<1,MV.NO> THEN
        CHG.CCY = R.NEW(TFS.CHG.CCY)<1,MV.NO>
        IF NOT(CHG.CCY) THEN CHG.CCY = R.NEW(TFS.CURRENCY)<1,MV.NO> :','
        IF CHG.CCY EQ LCCY THEN
            OFS.BODY := 'CHRG.AMT.LOCAL:1:1=' : R.NEW(TFS.CHG.AMT.LCY)<1,MV.NO> :','
        END ELSE
            OFS.BODY := 'CHRG.AMT.FCCY:1:1=' : R.NEW(TFS.CHG.AMT)<1,MV.NO> :','
            OFS.BODY := 'CHRG.AMT.LOCAL:1:1=' : R.NEW(TFS.CHG.AMT.LCY)<1,MV.NO> :','
        END
    END

    IF NOT(R.NEW(TFS.CHG.CODE)<1,MV.NO>) AND NOT(R.NEW(TFS.CHG.AMT)<1,MV.NO>) THEN
        OFS.BODY := 'WAIVE.CHARGES:1:1=YES,'
    END

    OFS.BODY := 'T24.FS.REF:1:1=' : ID.NEW :','
    IF R.NEW(TFS.CHEQUE.DRAWN)<1,MV.NO> THEN
        OFS.BODY := 'US.CHEQUE.DRAWN:1:1=' : R.NEW(TFS.CHEQUE.DRAWN)<1,MV.NO> :','
    END
*
    IF R.NEW(TFS.NARRATIVE)<1,MV.NO> THEN
        OFS.BODY := 'US.PAYEE.DETS:1:1=' : R.NEW(TFS.NARRATIVE)<1,MV.NO> :','
    END

    GOSUB FILL.IN.DENOMINATIONS

*S Anitha 08/05/09 Anti Money Laundering Gap for Multi Line Teller
*    CALL GET.LOC.REF.UPDATE(OFS.BDY)
    APAP.TFS.getLocRefUpdate(OFS.BDY) ;*R22 Manual Conversion
    
    OFS.BODY:= OFS.BDY
*E Anitha 08/05/09 Anti Money Laundering Gap for Multi Line Teller


RETURN
*========================================================================
DETERMINE.CR.DR.SIDES:

    ID.TTXN = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.INTERFACE.AS>
    CR.TXN.CODE = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.CR.TXN.CODE>
    CALL F.READ(FN.TTXN,ID.TTXN,R.TTXN,F.TTXN,ERR.TTXN)
    IF R.TTXN THEN
        TXN.CODE.1 = R.TTXN<TT.TR.TRANSACTION.CODE.1>
        IF TXN.CODE.1 EQ CR.TXN.CODE THEN
            CR.SIDE = 1
            DR.SIDE = 2
        END ELSE
            CR.SIDE = 2
            DR.SIDE = 1
        END
    END ELSE
        PROCESS.GOAHEAD = 0
    END

RETURN
*========================================================================
CHECK.CREDIT.ACC.TYPE:

    ! 18 SEP 07 - Sathish PS /s
    CR.AC.CUS = R.CR.AC<AC.CUSTOMER>
    ! 18 SEP 07 - Sathish PS /e
RETURN
*=======================================================================
CHECK.FOR.REGCC:

    REGCC = 0
    TT.LREF.FIELDS = 'US.ITEMSORTCODE' :@FM: 'US.ITEM.EXPDATE' :@FM: 'US.ITEM.AMOUNT' ;*R22 Manual Conversion
    CALL GET.LOC.REF.CACHE('TELLER',TT.LREF.FIELDS,TT.LREF.POSNS,TT.LREF.ERR)
    REGCC.1 = NOT(TT.LREF.ERR)
    REGCC.2 = (R.NEW(TFS.CURRENCY)<1,MV.NO> EQ LCCY)        ;* 08/03/05 - Ganesh Prasad s/e
    REGCC.3 = (R.NEW(TFS.EXP.SCHEDULE)<1,MV.NO> NE '')      ;* 08/03/05 - Sathish PS s/e
    REGCC.4 = TFS$R.TFS.PAR<TFS.PAR.TFS.EXPOSURE> EQ 'REGCC'          ;* 29 AUG 07 - Sathish PS s/e
    REGCC = REGCC.1 * REGCC.2 * REGCC.3

RETURN
*=======================================================================
! 29 AUG 07 - Sathish PS /s
UPDATE.TFS.EXPOSURE.DETAILS:

    IF TFS$R.TFS.PAR<TFS.PAR.EXPOSURE.METHOD> EQ 'FLOAT' THEN         ;* 26 SEP 07 - Sathish PS s/e
        IF (R.NEW(TFS.NET.ENTRY) NE 'NO' AND R.NEW(TFS.NETTED.ENTRY)<1,MV.NO> EQ 'YES') OR (R.NEW(TFS.NET.ENTRY) EQ 'NO') THEN    ;* 04 SEP 07 - Sathish PS s/e
            EXP.DATES = R.NEW(TFS.EXP.DATE)<1,MV.NO> ; EXP.AMTS = R.NEW(TFS.EXP.AMT)<1,MV.NO>
            EXP.DATE.CNT = 1
            LOOP
                REMOVE EXP.DATE FROM EXP.DATES SETTING NEXT.EXP.DATE.POS
                REMOVE EXP.AMT FROM EXP.AMTS SETTING NEXT.EXP.AMT.POS
            WHILE EXP.DATE : NEXT.EXP.DATE.POS DO

                OFS.BODY := 'LOCAL.REF:': EXP.DAT.POS :':': EXP.DATE.CNT :'=': EXP.DATE :','
                OFS.BODY := 'LOCAL.REF:': EXP.AMT.POS :':': EXP.DATE.CNT :'=': EXP.AMT  :','

                EXP.DATE.CNT += 1

            REPEAT

            OFS.BODY := 'TFS.EXP.ACCT:1:1=': CR.AC :','
            OFS.BODY := 'TFS.EXP.CCY:1:1=': R.NEW(TFS.CURRENCY)<1,MV.NO> :','
        END         ;* 04 SEP 07 - Sathish PS s/e
    END   ;* 26 SEP 07 - Sathish PS s/e

RETURN
! 29 AUG 07 - Sathish PS /e
*-----------------------------------------------------------------------
FILL.IN.DENOMINATIONS:

* Update our own Local Refs in TELLER
    IF R.NEW(TFS.CR.DEN.UNIT)<1,MV.NO> THEN
        ALL.UNITS = R.NEW(TFS.CR.DEN.UNIT)<1,MV.NO>
        NO.OF.UNITS = DCOUNT(ALL.UNITS,@SM) ;*R22 Manual Conversion
        FOR SV.COUNT = 1 TO NO.OF.UNITS
            IF R.NEW(TFS.CR.DEN.UNIT)<1,MV.NO,SV.COUNT> NE '' THEN
                OFS.BODY := 'LOCAL.REF:': CR.DEN.POS :':':SV.COUNT:'=':R.NEW(TFS.CR.DENOM)<1,MV.NO,SV.COUNT> :','
                OFS.BODY := 'LOCAL.REF:': CR.UNIT.POS :':': SV.COUNT:'=':R.NEW(TFS.CR.DEN.UNIT)<1,MV.NO,SV.COUNT> :','
                OFS.BODY := 'LOCAL.REF:': CR.SER.POS :':': SV.COUNT:'=':R.NEW(TFS.CR.SERIAL.NO)<1,MV.NO,SV.COUNT> :','
            END
        NEXT SV.COUNT
    END
*
    IF R.NEW(TFS.DR.DEN.UNIT)<1,MV.NO> THEN
        ALL.UNITS = R.NEW(TFS.DR.DEN.UNIT)<1,MV.NO>
        NO.OF.UNITS = DCOUNT(ALL.UNITS,@SM)
        FOR SV.COUNT = 1 TO NO.OF.UNITS
            IF R.NEW(TFS.DR.DEN.UNIT)<1,MV.NO,SV.COUNT> NE '' THEN
                OFS.BODY := 'LOCAL.REF:': DR.DEN.POS :':': SV.COUNT:'=':R.NEW(TFS.DR.DENOM)<1,MV.NO,SV.COUNT> :','
                OFS.BODY := 'LOCAL.REF:': DR.UNIT.POS :':': SV.COUNT:'=':R.NEW(TFS.DR.DEN.UNIT)<1,MV.NO,SV.COUNT> :','
                OFS.BODY := 'LOCAL.REF:': DR.SER.POS :':': SV.COUNT:'=':R.NEW(TFS.DR.SERIAL.NO)<1,MV.NO,SV.COUNT> :','
            END
        NEXT SV.COUNT
    END

RETURN
*=======================================================================
INIT:

    PROCESS.GOAHEAD = 1
    OFS.BODY = ''

    FN.AC = 'F.ACCOUNT' ; F.AC = ''
    FN.TTXN = 'F.TELLER.TRANSACTION' ; F.TTXN = ''

    IF R.NEW(TFS.REVERSAL.MARK)<1,MV.NO> NE '' THEN PROCESS.GOAHEAD = 0
*
    TT.LREF.NAMES = 'TFS.CR.DENOM' :@FM: 'TFS.CR.UNIT' :@FM: 'TFS.CR.SERIAL'
    TT.LREF.NAMES := @FM: 'TFS.DR.DENOM' :@FM: 'TFS.DR.UNIT' :@FM: 'TFS.DR.SERIAL'
    TT.LREF.NAMES := @FM: 'TFS.EXP.DAT' :@FM: 'TFS.EXP.AMT'   ;* 29 AUG 07 - Sathish PS s/e
    TT.LREF.POSNS = '' ; TT.LREF.ERR = ''
    CALL GET.LOC.REF.CACHE("TELLER",TT.LREF.NAMES,TT.LREF.POSNS,TT.LREF.ERR)
    IF TT.LREF.ERR THEN
        ETEXT = RAISE(TT.LREF.ERR<1>)
        PROCESS.GOAHEAD = 0
    END ELSE
        CR.DEN.POS = TT.LREF.POSNS<1> ; CR.UNIT.POS = TT.LREF.POSNS<2> ; CR.SER.POS = TT.LREF.POSNS<3>
        DR.DEN.POS = TT.LREF.POSNS<4> ; DR.UNIT.POS = TT.LREF.POSNS<5> ; DR.SER.POS = TT.LREF.POSNS<6>
        EXP.DAT.POS = TT.LREF.POSNS<7> ; EXP.AMT.POS = TT.LREF.POSNS<8>
    END
*** TESTING /S
    TFS.APP = 'CATEGORY' ; TFS.APP.LREF.NAMES = 'TFS.CCY.MKT' ; TFS.CCY.MKT.POS = '' ; TFS.APP.LREF.ERR = ''
    TFS.APPL.LREF.POSNS = ''
    CALL GET.LOC.REF.CACHE(TFS.APP,TFS.APP.LREF.NAMES,TFS.APP.LREF.POSNS,TFS.APP.LREF.ERR)
    IF TFS.APP.LREF.POSNS THEN
        TFS.CCY.MKT.POS = TFS.APP.LREF.POSNS<1>
    END
*** TESTING /E

    FN.CAT = 'F.CATEGORY' ; F.CAT = ''
    CALL OPF(FN.CAT,F.CAT)

    FN.CCY = 'F.CURRENCY' ; F.CCY = ''
    CALL OPF(FN.CCY,F.CCY)

RETURN
*========================================================================
END


