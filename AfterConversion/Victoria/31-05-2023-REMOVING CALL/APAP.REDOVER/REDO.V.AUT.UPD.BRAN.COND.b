* @ValidationCode : Mjo1ODE5NjgxNTk6Q3AxMjUyOjE2ODU1MzYwMTE5NDY6dmljdG86LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:56:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.UPD.BRAN.COND
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: Authorisation routine
*------------
*DESCRIPTION:
*------------
* This routine is the authorisation routine for the versions of FX, FT and TT
* The routine is used to update the field "FX.POSN" field of the local template
* "REDO.APAP.FX.BRN.COND"
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 09-NOV-2010   A.SabariKumar       ODR-2010-07-0075       Initial Creation
* 23-MAR-2010   A.SabariKumar       PACS00038161           HD FIX
* 20-OCT-2011   Pradeep S           PACS00149084           Branch validations included
* 16-Jul-2011   Karthi KR           PACS00207661           Modified
* 11-NOV-2013   Vignesh Kumaar R    PACS00325160           FX Branch and Overall Position update
* 03-AUG-2014   Vignesh Kumaar R    PACS00384795           POSITION LIMIT HAS TO BE BASED ON THE SELL
*-----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*10-04-2023              Samaran T                R22 Manual Code conversion                     Call Routine Format Modified
*----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FOREX
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.CURRENCY
*
    $INSERT I_F.REDO.APAP.FX.BRN.COND
    $INSERT I_F.REDO.APAP.FX.BRN.POSN
    $INSERT I_F.REDO.APAP.USER.LIMITS
    $INSERT I_F.REDO.FXSN.TXN.VERSION

    GOSUB PERF.PRE.VAL          ;* PERFORMANCE FIX TO EXCLUDE THE CALL FOR FX POSITION

    IF Y.PERF.FLAG ELSE
        GOSUB OPENFILES
        GOSUB CHECK.VALIDATION
        IF Y.FX.FLAG THEN
            GOSUB PROCESS
        END
    END
RETURN

*----------------
CHECK.VALIDATION:
*----------------
* Fix for PACS00325160 [FX Branch and Overall Position update]

    IF APPLICATION EQ 'FOREX' THEN
        Y.FX.FLAG = 1
    END ELSE
        CALL CACHE.READ(FN.REDO.FXSN.TXN.VERSION,"SYSTEM",R.REDO.FXSN.TXN.VERSION,REDO.FXSN.TXN.VERSION.ERR)
        GET.FX.VERSION.LIST = R.REDO.FXSN.TXN.VERSION<REDO.TXN.VER.VERSION.NAME>
        CHANGE @VM TO @FM IN GET.FX.VERSION.LIST
        Y.GET.VERSION.NAME = APPLICATION:PGM.VERSION
        Y.ARCID.FT.LIST = ''

        LOCATE Y.GET.VERSION.NAME IN GET.FX.VERSION.LIST SETTING VERSION.POS THEN
            Y.FX.FLAG = 1
        END ELSE

            IF Y.GET.VERSION.NAME EQ 'FUNDS.TRANSFER,AI.REDO.CARD.OUT' OR Y.GET.VERSION.NAME EQ 'FUNDS.TRANSFER,AI.REDO.BEN.CARD.PAY' OR Y.GET.VERSION.NAME[1,31] EQ 'FUNDS.TRANSFER,AI.REDO.CARD.OUT' OR Y.GET.VERSION.NAME[1,35] EQ 'FUNDS.TRANSFER,AI.REDO.BEN.CARD.PAY' THEN
                Y.FX.FLAG = 1
            END
        END
    END
RETURN

* End of Fix

*-------------
OPENFILES:
*--------------
* Initialise/Open necesaary variables/Files

    R.USR.LIM = ''
    Y.INPUTTER = ''
    Y.DATE.TIME = ''
    Y.USER = ''
    Y.FX.FLAG = ''

    FN.FOREX = 'F.FOREX'
    F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.REDO.FXSN.TXN.VERSION = 'F.REDO.FXSN.TXN.VERSION'
    F.REDO.FXSN.TXN.VERSION = ''
    CALL OPF(FN.REDO.FXSN.TXN.VERSION,F.REDO.FXSN.TXN.VERSION)

    FN.REDO.APAP.FX.BRN.COND = 'F.REDO.APAP.FX.BRN.COND'
    F.REDO.APAP.FX.BRN.COND = ''
    CALL OPF(FN.REDO.APAP.FX.BRN.COND,F.REDO.APAP.FX.BRN.COND)

    FN.REDO.APAP.FX.BRN.POSN = 'F.REDO.APAP.FX.BRN.POSN'
    F.REDO.APAP.FX.BRN.POSN = ''
    CALL OPF(FN.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN)

    FN.REDO.APAP.USER.LIMITS = 'F.REDO.APAP.USER.LIMITS'
    F.REDO.APAP.USER.LIMITS = ''
    CALL OPF(FN.REDO.APAP.USER.LIMITS,F.REDO.APAP.USER.LIMITS)


*PACS00149084 - S
    LOC.REF.APPL = "FOREX"
    LOC.REF.FIELDS = 'L.FX.BRANCH'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    POS.FX.BRANCH = LOC.REF.POS<1,1>
*PACS00149084 - E

RETURN

*-------------------------------------------------------------------------------------------------------
PROCESS:
*-------------
* The section process the GOSUB's based on the application involved and

    Y.APPLICATION = APPLICATION
    Y.FUNCTION = V$FUNCTION
    Y.ID = 'SYSTEM'

*PACS00149084 - S
    IF Y.APPLICATION EQ "FOREX" THEN
        Y.COMPANY = R.NEW(FX.LOCAL.REF)<1,POS.FX.BRANCH>
    END ELSE
        Y.COMPANY = ID.COMPANY
    END
*PACS00149084 - E

    Y.USD.AMOUNT = ''

    CALL F.READU(FN.REDO.APAP.FX.BRN.COND,Y.ID,R.BRANCH.COND,F.REDO.APAP.FX.BRN.COND,COND.ERR,'')

    Y.TXN.POSN = R.BRANCH.COND<REDO.BRN.COND.FX.POSN>

    CALL F.READU(FN.REDO.APAP.FX.BRN.POSN,Y.COMPANY,R.BRN.POSN,F.REDO.APAP.FX.BRN.POSN,BRN.ERR,'')
    Y.BRN.TDY.VALUE = R.BRN.POSN<REDO.BRN.POSN.BRN.TDY.TXN.VALUE>

    APAP.REDOVER.redoVCallUsdEqv(Y.USD.AMOUNT,Y.REC.STATUS,CURR.NO) ;* MANUAL R22 CODE CONVERSION
    IF V$FUNCTION EQ 'A' AND (Y.REC.STATUS EQ 'RNAU' OR Y.REC.STATUS EQ 'RNAO') THEN
        GOSUB UPDATE.DLY.LIMIT
    END

    IF R.BRANCH.COND EQ '' THEN
        RETURN
    END

* PACS00207661 - S

    Y.BUY.SELL.FLAG = ''
    IF Y.APPLICATION EQ 'FOREX' THEN
        Y.FX.BOUGHT.CCY = R.NEW(FX.CURRENCY.BOUGHT)

        IF (Y.REC.STATUS NE 'RNAU' AND Y.REC.STATUS NE 'RNAO') THEN

            IF Y.FX.BOUGHT.CCY NE LCCY THEN
                Y.BUY.SELL.FLAG = 1
                Y.FX.POSN = Y.TXN.POSN + Y.USD.AMOUNT
            END
            IF Y.FX.BOUGHT.CCY EQ LCCY THEN
                Y.FX.POSN = Y.TXN.POSN - Y.USD.AMOUNT
            END
            R.BRANCH.COND<REDO.BRN.COND.FX.POSN> = Y.FX.POSN
        END ELSE
            IF Y.FX.BOUGHT.CCY EQ LCCY THEN
                Y.BUY.SELL.FLAG = 1
                Y.FX.POSN = Y.TXN.POSN + Y.USD.AMOUNT
            END
            IF Y.FX.BOUGHT.CCY NE LCCY THEN
                Y.FX.POSN = Y.TXN.POSN - Y.USD.AMOUNT
            END
            R.BRANCH.COND<REDO.BRN.COND.FX.POSN> = Y.FX.POSN
        END

* PACS00207661 - E

    END ELSE

        IF APPLICATION EQ 'TELLER' THEN
            Y.DB.CR.MARK = R.NEW(TT.TE.DR.CR.MARKER)
            Y.TT.CCY = R.NEW(TT.TE.CURRENCY.1)

* Fix for PACS00384795 [POSITION LIMIT HAS TO BE BASED ON THE SELL]

            IF Y.DB.CR.MARK EQ 'DEBIT' AND Y.TT.CCY NE LCCY THEN

* End of Fix

                Y.DC.FLAG = 'BUY'
            END ELSE
                Y.DC.FLAG = 'SELL'
            END
        END

        IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
            IF R.NEW(FT.DEBIT.CURRENCY) NE LCCY THEN
                Y.DC.FLAG = 'BUY'
            END ELSE
                Y.DC.FLAG = 'SELL'
            END
        END

        IF V$FUNCTION EQ 'R' OR ((Y.REC.STATUS EQ 'RNAU' OR Y.REC.STATUS EQ 'RNAO') AND V$FUNCTION EQ 'A') THEN
            IF Y.DC.FLAG EQ 'BUY' THEN
                Y.FX.POSN = Y.TXN.POSN - Y.USD.AMOUNT
            END ELSE
                Y.BUY.SELL.FLAG = 1
                Y.FX.POSN = Y.TXN.POSN + Y.USD.AMOUNT
            END
        END

        IF V$FUNCTION EQ 'I' OR ((Y.REC.STATUS EQ 'INAU' OR Y.REC.STATUS EQ 'INAO') AND V$FUNCTION EQ 'A') THEN
            IF Y.DC.FLAG EQ 'BUY' THEN
                Y.BUY.SELL.FLAG = 1
                Y.FX.POSN = Y.TXN.POSN + Y.USD.AMOUNT
            END ELSE
                Y.FX.POSN = Y.TXN.POSN - Y.USD.AMOUNT
            END
        END

        R.BRANCH.COND<REDO.BRN.COND.FX.POSN> = Y.FX.POSN

    END

    IF R.BRN.POSN NE '' THEN
        GOSUB WRITE.POSN.TABLE
    END

    CALL F.WRITE(FN.REDO.APAP.FX.BRN.COND,Y.ID,R.BRANCH.COND)
RETURN

*-------------------------------------------------------------------------------------------------------
WRITE.POSN.TABLE:
*----------------

* The section makes a write to the local template REDO.APAP.FX.BRN.POSN for FT and TT transactions

*    IF (Y.REC.STATUS NE 'RNAU' OR Y.REC.STATUS NE 'RNAO') THEN

    IF Y.BUY.SELL.FLAG THEN
        R.BRN.POSN<REDO.BRN.POSN.BRN.TDY.TXN.VALUE> = Y.USD.AMOUNT + Y.BRN.TDY.VALUE
    END ELSE
        R.BRN.POSN<REDO.BRN.POSN.BRN.TDY.TXN.VALUE> = Y.BRN.TDY.VALUE - Y.USD.AMOUNT
    END
    CALL F.WRITE(FN.REDO.APAP.FX.BRN.POSN,Y.COMPANY,R.BRN.POSN)
RETURN

*--------------------------------------------------------------------------------------------------------
UPDATE.DLY.LIMIT:
*--------------------
*
    BEGIN CASE
        CASE Y.APPLICATION EQ 'FOREX'
            GOSUB FX.PROCESS
        CASE Y.APPLICATION EQ 'MM.MONEY.MARKET'
            GOSUB MM.PROCESS
        CASE Y.APPLICATION EQ 'SEC.TRADE'
            GOSUB SC.PROCESS
    END CASE
RETURN

*--------------------------------------------------------------------------------------------------------
FX.PROCESS:
*-----------
    Y.INPUTTER = R.OLD(FX.INPUTTER)
    GOSUB READ.USR.LIM
    LOCATE 'FX' IN Y.CURR.APP SETTING Y.FX.POS THEN
        Y.DATE.TIME = R.NEW(FX.DATE.TIME)
        Y.TXN.DATE = '20':Y.DATE.TIME[1,6]
        Y.DAILY.TXN.AMT = R.USR.LIM<REDO.USR.LIM.DLY.TOT.TXN.AMT,Y.FX.POS>
        Y.ACTUAL.DLY = Y.DAILY.TXN.AMT - Y.USD.AMOUNT
        IF Y.ACTUAL.DLY EQ 0 THEN
            Y.ACTUAL.DLY = ''
        END
        R.USR.LIM<REDO.USR.LIM.DLY.TOT.TXN.AMT,Y.FX.POS> = Y.ACTUAL.DLY
        GOSUB WRITE.USR.LIM
    END
RETURN
*--------------------------------------------------------------------------------------------------------
MM.PROCESS:
*-----------
    Y.INPUTTER = R.OLD(MM.INPUTTER)
    GOSUB READ.USR.LIM
    LOCATE 'MM' IN Y.CURR.APP SETTING Y.MM.POS THEN
        Y.DATE.TIME = R.NEW(MM.DATE.TIME)
        Y.TXN.DATE = '20':Y.DATE.TIME[1,6]
        Y.DAILY.TXN.AMT = R.USR.LIM<REDO.USR.LIM.DLY.TOT.TXN.AMT,Y.MM.POS>
        Y.ACTUAL.DLY = Y.DAILY.TXN.AMT - Y.USD.AMOUNT
        IF Y.ACTUAL.DLY EQ 0 THEN
            Y.ACTUAL.DLY = ''
        END
        R.USR.LIM<REDO.USR.LIM.DLY.TOT.TXN.AMT,Y.MM.POS> = Y.ACTUAL.DLY
        GOSUB WRITE.USR.LIM
    END
RETURN
*--------------------------------------------------------------------------------------------------------
SC.PROCESS:
*-----------
    Y.INPUTTER  = R.OLD(SC.SBS.INPUTTER)
    GOSUB READ.USR.LIM
    LOCATE 'SC' IN Y.CURR.APP SETTING Y.SC.POS THEN
        Y.DATE.TIME = R.NEW(SC.SBS.DATE.TIME)
        Y.TXN.DATE = '20':Y.DATE.TIME[1,6]
        Y.DAILY.TXN.AMT = R.USR.LIM<REDO.USR.LIM.DLY.TOT.TXN.AMT,Y.SC.POS>
        Y.ACTUAL.DLY = Y.DAILY.TXN.AMT - Y.USD.AMOUNT
        IF Y.ACTUAL.DLY EQ 0 THEN
            Y.ACTUAL.DLY = ''
        END
        R.USR.LIM<REDO.USR.LIM.DLY.TOT.TXN.AMT,Y.SC.POS> = Y.ACTUAL.DLY
        GOSUB WRITE.USR.LIM
    END
RETURN
*--------------------------------------------------------------------------------------------------------
READ.USR.LIM:
*--------------
* Read the USer Limit template with the USer who inputted the Original transation

    Y.USER = FIELD(Y.INPUTTER,'_',2)
    CALL F.READU(FN.REDO.APAP.USER.LIMITS,Y.USER,R.USR.LIM,F.REDO.APAP.USER.LIMITS,USR.LIM.ERR,'')
    Y.CURR.APP = R.USR.LIM<REDO.USR.LIM.APPLICATION>
    CHANGE @VM TO @FM IN Y.CURR.APP
RETURN

*--------------------------------------------------------------------------------------------------------
WRITE.USR.LIM:
*--------------
* Writes the value to the USER.LIMITS template based on reversal amount

    IF TODAY EQ Y.TXN.DATE THEN
        CALL F.WRITE(FN.REDO.APAP.USER.LIMITS,Y.USER,R.USR.LIM)
    END
RETURN

*-----------*
PERF.PRE.VAL:
*-----------*

    Y.PERF.FLAG = ''

    BEGIN CASE
        CASE APPLICATION EQ 'FOREX'
            Y.PERF.DCCY = R.NEW(FX.CURRENCY.SOLD)
            Y.PERF.CCCY = R.NEW(FX.CURRENCY.BOUGHT)

        CASE APPLICATION EQ 'FUNDS.TRANSFER'
            Y.PERF.DCCY = R.NEW(FT.DEBIT.CURRENCY)
            Y.PERF.CCCY = R.NEW(FT.CREDIT.CURRENCY)

        CASE APPLICATION EQ 'TELLER'
            Y.PERF.DCCY = R.NEW(TT.TE.CURRENCY.1)
            Y.PERF.CCCY = R.NEW(TT.TE.CURRENCY.2)

    END CASE

    IF Y.PERF.DCCY EQ LCCY AND Y.PERF.CCCY EQ LCCY THEN
        Y.PERF.FLAG = '1'
    END

RETURN

*--------------------------------------------------------------------------------------------------------
END
