* @ValidationCode : MjotMjA0MTcyNzg0MTpDcDEyNTI6MTY4NDg0MjE1MzQ0MzpJVFNTOi0xOi0xOjE4OjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 18
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VVR.CALC.AMOUNTS
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SHANKAR RAJU
* PROGRAM NAME: REDO.V.INP.RAISE.OVERRIDE
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*
*    Input routine attached to versions,
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE         WHO                REFERENCE          DESCRIPTION
*
*  05.07.2010   SHANKAR RAJU       ODR-2009-12-0285   ADDED NEW CHECKS
*  21.02.2011   KAVITHA            HD1054080-S        CHANGES MADE FOR VERSION REFRESHING OF WAIVE TAX CHARGE FIELDS
*  20.04.2001   Bharath G          PACS00032271       Base amount should not be modified
*  12.12.2011   J.Costa C.         PACS00163628       Complete Redesign
*  16.02.2012   V. Panchi          issues GR2         Take the correct currency
*  20-03-2013   Arundev            PACS00254620       RTC-613322 Cadena 30911 (Issues Criticos)
*  22-04-2013   Vignesh Kumaar R   PACS00263944       NET.AMOUNT not calculating the Tax and Charge amount
*  11.04.2023   Conversion Tool       R22             Auto Conversion     - FM TO @FM, VM TO @VM, = TO EQ
*  11.04.2023   Shanmugapriya M       R22             Manual Conversion   - Add call routine prefix
*
*----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_TT.COMMON
    $INSERT I_TT.EQUATE
*
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FT.COMMISSION.TYPE
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
    R.NEW(TT.TE.CHARGE.CUSTOMER)  = ""
    R.NEW(TT.TE.CHARGE.ACCOUNT)   = ""
    R.NEW(TT.TE.CHARGE.CATEGORY)  = ""
    R.NEW(TT.TE.CHRG.DR.TXN.CDE)  = ""
    R.NEW(TT.TE.CHRG.CR.TXN.CDE)  = ""
    R.NEW(TT.TE.CHRG.AMT.LOCAL)   = ""
    R.NEW(TT.TE.CHRG.AMT.FCCY)    = ""
    R.NEW(TT.TE.CHARGE.CODE)      = ""
    R.NEW(TT.TE.NET.AMOUNT)       = ""
    R.NEW(TT.TE.DEALER.DESK)      = "00"

    R.NEW(TT.TE.CUSTOMER.1) = ''          ;* Fix for PACS00263944

    IF AF EQ TT.TE.AMOUNT.LOCAL.1 THEN                                  ;** R22 Auto conversion - = TO EQ
        R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1>         = Y.BASE.AMT
        R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1>         = Y.BASE.AMT
    END ELSE
        R.NEW(TT.TE.AMOUNT.FCY.1)<1,1>           = Y.BASE.AMT
        R.NEW(TT.TE.AMOUNT.FCY.2)<1,1>           = Y.BASE.AMT
    END

*
*CALL REDO.HANDLE.COMM.TAX.FIELDS
** R22 Manual conversion
    CALL APAP.TAM.redoHandleCommTaxFields
*
    GOSUB CASH.WTHD.FCY         ;* 2012MAR19 - V.N.L. - Temporal para Venta de ME - DB. Cta. ML
*
RETURN
*
* ========================
UPDATE.TRAN.AMOUNT.FIELDS:
* ========================
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
        R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>  = COMI
        R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS> = R.NEW(TT.TE.NET.AMOUNT)
    END ELSE
        R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS> = COMI
        R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS> = R.NEW(TT.TE.NET.AMOUNT)
    END
*
RETURN
*
* ============
CASH.WTHD.FCY:
* ============
*
    IF MESSAGE EQ "" AND AF EQ TT.TE.AMOUNT.FCY.1 AND R.NEW(TT.TE.CURRENCY.1) NE LCCY THEN
        GOSUB UPDATE.TRAN.AMOUNT.FIELDS
    END
*
RETURN
*
*----------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------
*
    PROCESS.GOAHEAD = "1"
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
*
    Y.BASE.AMT         = ''
*
    LOC.REF.APPLICATION = "TELLER"
    LOC.REF.FIELDS      = 'L.TT.BASE.AMT'
    LOC.REF.FIELDS<2>  = "L.DEBIT.AMOUNT"
    LOC.REF.FIELDS<3>  = "L.CREDIT.AMOUNT"
    CHANGE @FM TO @VM IN LOC.REF.FIELDS
*
    LREF.POS         = ''
*
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LREF.POS)
    POS.BASE.AMT     = LREF.POS<1,1>
    DEBIT.POS        = LREF.POS<1,2>
    CREDIT.POS       = LREF.POS<1,3>
*
    IF COMI NE "" AND ((AF EQ TT.TE.AMOUNT.LOCAL.1) OR (AF EQ TT.TE.AMOUNT.FCY.1)) AND MESSAGE NE "VAL" THEN
        Y.BASE.AMT       = COMI
        R.NEW(TT.TE.LOCAL.REF)<1,POS.BASE.AMT> = Y.BASE.AMT
    END
*
    IF MESSAGE EQ "VAL" AND ((AF EQ TT.TE.AMOUNT.LOCAL.1 AND R.NEW(TT.TE.CURRENCY.1) EQ LCCY) OR (AF EQ TT.TE.AMOUNT.FCY.1 AND R.NEW(TT.TE.CURRENCY.1) NE LCCY)) THEN
        WDB = R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>
        WCR = R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS>
        IF (WDB EQ WCR AND (WDB EQ "" OR WDB EQ 0)) OR WDB EQ "" OR WCR EQ "" OR WDB EQ 0 OR WCR EQ 0 THEN
            IF COMI NE "" AND COMI GT 0 THEN
                GOSUB UPDATE.TRAN.AMOUNT.FIELDS
            END
        END
    END
*
*
RETURN
*
*----------------------------------------------------------------------------------------------------------
OPEN.FILES:
*~~~~~~~~~~
*
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT);
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

**PACS00254620-start
    VERSION.LIST = 'TELLER,REDO.CHEQUE.GOVERN.NOTAX.TRF.CHQ'
    Y.CURR.VERSION = APPLICATION:PGM.VERSION
**PACS00254620-End

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
*
                IF MESSAGE EQ "VAL" THEN
                    IF Y.CURR.VERSION NE VERSION.LIST THEN    ;*PACS00254620
                        PROCESS.GOAHEAD = ""
                    END
                END
*
        END CASE
        LOOP.CNT +=1
*
    REPEAT
*
RETURN
*
END
