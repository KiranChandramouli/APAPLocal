* @ValidationCode : MjotMTExNzY4NTAzNTpDcDEyNTI6MTY4NDQ5MTAzMTMxODpJVFNTOi0xOi0xOjI1OToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 259
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.COL.CALC.SALD.DISP
*-----------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : COLLATERAL
* Attached as     : INPUT ROUTINE
* Primary Purpose : CALCULAR EL SALDO DISPONIBLE DE LA GARANTIA DURANTE LA CREACION
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
*
*-----------------------------------------------------------------------------
* Modification History:
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo - TAM Latin America
* Date            : February 23 2013
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - added APAP.TAM, CALL RTN FORMAT MODIFIED
*-----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $USING APAP.AA
    $USING APAP.REDOSRTN
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS
*
RETURN
*
* =========
INITIALISE:
* =========
*
    Y.AVA.BAL.POS = ''
    Y.AVA.BAL.NAME = 'L.COL.VAL.AVA'
*
    Y.ID.LOAN.NAME = 'L.AC.LK.COL.ID'
    Y.ID.LOAN.POS  = ''

    Y.MAX.PRESTAR.NAME = 'L.COL.LN.MX.VAL'
    Y.MAX.PRESTAR.POS = ''

    LOC.REF.APPL = 'COLLATERAL'
    LOC.REF.FIELDS = Y.AVA.BAL.NAME :@VM : Y.ID.LOAN.NAME :@VM : Y.MAX.PRESTAR.NAME
    LOC.REF.POS = ''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)

    Y.AVA.BAL.POS = LOC.REF.POS<1,1>
    Y.ID.LOAN.POS = LOC.REF.POS<1,2>
    Y.MAX.PRESTAR.POS = LOC.REF.POS<1,3>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    R.AA.ARRANGEMENT = ''

    Y.ERR = ''
    Y.AA.BALANCE = ''
    COL.ID.LINKED = ''

    Y.PRODUCT.ID.CUR = ''
    Y.RISK.PERC      = 0

    Y.AV.USE    = ''
    Y.AVAL.USE  = ''
    Y.AVA.AMT   = ''
    Y.AVAIL.AMT = ''
    Y.VNG       = ''
    Y.ADD       = ''
    Y.AVL       = ''
    Y.BAL.DIF   = ''
    Y.BAL.NOCH  = ''
    Y.AA.ID.OLD = ''
    Y.AA.ID.NEW = ''
    Y.TOTAL.AMT = ''
    Y.AVBAL.OLD = R.OLD(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS>

RETURN

* =========
OPEN.FILES:
* =========
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
RETURN
*
* ======
PROCESS:
* ======
    LOAN.AA.ID   = R.NEW(COLL.LOCAL.REF)<1,Y.ID.LOAN.POS>
    IF NOT(LOAN.AA.ID) THEN
        GOSUB SET.AVAL.BAL.NLOAN  ;*Asignar el disponible de una garantia si esta no esta atada a ningun prestamo
    END

    GOSUB GET.AAID.SM ;* PACS00307565 - S/E

    IF Y.ERR THEN
        RETURN
    END
*Get Loan balance
*    CALL REDO.COL.GET.AA.BALANCE (LOAN.ACCOUNT.NUMBER,Y.AA.BALANCE)

    IF Y.AA.BALANCE EQ 0 OR Y.AA.BALANCE EQ '' THEN
        GOSUB SET.AVAL.BAL.NLOAN  ;*Cuando el saldo del prestamo es 0 o menor se asignara como si no tuviera prestamo atado
*OVERRIDE INDICANDO QUE EL PRESTAMO NO TIENE SALDO PENDIENTE PAGO
        RETURN
    END

*CALL REDO.COL.AA.GET.LINKS.COL (LOAN.AA.ID,COL.ID.LINKED) ;*R22 MANUAL CODE CONVERSION
    CALL APAP.AA.redoColAaGetLinksCol(LOAN.AA.ID,COL.ID.LINKED) ;*R22 MANUAL CODE CONVERSION
    GOSUB GET.RISK.PERCENT
    GOSUB CALC.AMT.AVAILABLE
RETURN

*=============================
GET.AAID.SM:
*=============================
    Y.AA.NUM = DCOUNT(LOAN.AA.ID,@SM)
    Y.VAR = 1
    LOOP
    WHILE Y.VAR LE Y.AA.NUM
        LOAN.AA.ID = FIELD(LOAN.AA.ID,@SM,Y.VAR)
        GOSUB READ.AA.ACCT
        IF Y.ERR NE "" THEN
            BREAK
        END
        GOSUB GET.AA.CURBAL
        Y.VAR += 1 ;* R22 Auto conversion
    REPEAT
RETURN
*=============================
READ.AA.ACCT:
*=============================
    IF LOAN.AA.ID MATCHES "AA..." THEN    ;*GET THE INFORMATION FOR THE SALD FOR ARRANGEMENT
        GOSUB READ.AA.ARRANGEMENT
    END
    ELSE
        GOSUB READ.ACCOUNT
    END
RETURN
*=============================
READ.AA.ARRANGEMENT:
*=============================
    CALL F.READ(FN.AA.ARRANGEMENT, LOAN.AA.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, Y.ERR)
    LOAN.ACCOUNT.NUMBER = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    Y.PRODUCT.ID.CUR<1>  = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.PRODUCT.ID.CUR<2> = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
RETURN
*=============================
READ.ACCOUNT:
*=============================
    CALL F.READ(FN.ACCOUNT,LOAN.AA.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    LOAN.ACCOUNT.NUMBER = LOAN.AA.ID
    LOAN.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    GOSUB READ.AA.ARRANGEMENT
RETURN
*=============================
GET.AA.CURBAL:
*=============================
* Get outstanding from AA
*CALL REDO.S.GET.OUT.BALANCE(LOAN.AA.ID,Y.TOTAL.AMT) ;*R22 MANUAL CODE CONVERSION
    CALL APAP.REDOSRTN.redoSGetOutBalance(LOAN.AA.ID,Y.TOTAL.AMT) ;*R22 MANUAL CODE CONVERSION
    Y.AA.BALANCE += Y.TOTAL.AMT
RETURN
*==============================
SET.AVAL.BAL.NLOAN:
*==============================
*
    IF R.NEW(COLL.COLLATERAL.CODE) EQ 150 THEN
        GOSUB GET.RISK.PERCENT
* PACS00255616 - S
*         R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = (R.NEW(COLL.NOMINAL.VALUE)*100)/Y.RISK.PERC
        Y.AVA.AMT = (R.NEW(COLL.NOMINAL.VALUE)*100)/Y.RISK.PERC
        Y.AVAIL.AMT = DROUND(Y.AVA.AMT,2)
* PACS00255616 - E
        R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = Y.AVAIL.AMT
    END
    ELSE
        R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> =  R.NEW(COLL.LOCAL.REF)<1,Y.MAX.PRESTAR.POS>
    END

RETURN
*============================
CALC.AMT.AVAILABLE:
*============================

    IF R.NEW(COLL.COLLATERAL.CODE) EQ 150 THEN
        Y.VNG.OLD = R.OLD(COLL.NOMINAL.VALUE)
        Y.VNG.NEW = R.NEW(COLL.NOMINAL.VALUE)
* PACS00307565 - S
        Y.AA.ID.OLD = R.OLD(COLL.LOCAL.REF)<1,Y.ID.LOAN.POS>
        Y.AA.ID.NEW = R.NEW(COLL.LOCAL.REF)<1,Y.ID.LOAN.POS>
* PACS00307565 - E
        IF NOT(Y.VNG.OLD) THEN
            Y.VNG.DIF = ((R.NEW(COLL.NOMINAL.VALUE)*100)/Y.RISK.PERC)
        END ELSE
            Y.AV.USE   = ((R.NEW(COLL.NOMINAL.VALUE)*100)/Y.RISK.PERC)
            Y.AVAL.USE = DROUND(Y.AV.USE,2)
            Y.VNG.DIF = Y.VNG.NEW - Y.VNG.OLD

            IF Y.VNG.DIF NE 0 THEN
                GOSUB GET.AVA.AMTFLD  ;* PACS00307565 - S/E
            END
            ELSE
                GOSUB GET.AVA.VNG.NOCHG
            END
        END
    END
    ELSE
        Y.AVAL.USE =  R.NEW(COLL.LOCAL.REF)<1,Y.MAX.PRESTAR.POS>
        IF Y.AVAL.USE GT Y.AA.BALANCE THEN
            R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = Y.AVAL.USE - Y.AA.BALANCE
        END
        ELSE
            R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = 0
        END
    END

RETURN

*============================
GET.AVA.AMTFLD:
*============================
*
    Y.VNG = (Y.VNG.DIF * 100) / Y.RISK.PERC
    Y.VNG = DROUND(Y.VNG,2)
    Y.ADD = Y.VNG + Y.AVBAL.OLD
* PACS00307565 - S
    IF Y.AA.ID.OLD EQ Y.AA.ID.NEW AND Y.AVBAL.OLD THEN        ;* There is no change in arrangement id fld.
        GOSUB VAL.AAID.NOCHG
    END
    ELSE    ;* There is change in loan id fld.
        GOSUB VAL.AAID.CHG
    END
* PACS00307565 - E
RETURN

*===========================
VAL.AAID.NOCHG:
*===========================

    IF Y.ADD LT 0 THEN
        R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = 0.00
    END
    ELSE
        R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = Y.ADD
    END

RETURN

*===========================
VAL.AAID.CHG:
*===========================

    Y.BAL.CH = Y.AVAL.USE - Y.AA.BALANCE

    IF Y.BAL.CH GT 0 THEN
        R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = Y.BAL.CH
    END
    ELSE
        R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = 0
    END

RETURN

*============================
GET.AVA.VNG.NOCHG:
*============================

    Y.BAL.DIF = Y.AVAL.USE - Y.AA.BALANCE

    IF Y.BAL.DIF LT 0 THEN
        R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = 0.00
    END
    ELSE
        R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = Y.BAL.DIF
    END

RETURN

*==================================
GET.RISK.PERCENT:
*==================================
    IF R.NEW(COLL.COLLATERAL.CODE) NE 150 THEN
        RETURN
    END
*CALL APAP.TAM.REDO.COL.GET.RISK.DI (Y.PRODUCT.ID.CUR,Y.RISK.PERC)  ;*Rutina para calcular el % de riesgo ;* R22 Manual conversion
    CALL APAP.TAM.redoColGetRiskDi(Y.PRODUCT.ID.CUR,Y.RISK.PERC) ;* R22 Manual conversion
    IF NOT(Y.RISK.PERC)THEN
        Y.RISK.PERC = 100
    END
RETURN
END
