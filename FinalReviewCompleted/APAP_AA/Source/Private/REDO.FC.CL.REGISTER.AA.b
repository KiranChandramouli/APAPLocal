* @ValidationCode : MjotMTQ4ODQzNDk0NjpVVEYtODoxNjkwMjY0MDY3MTI0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:17:47
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
******************************************************************************
SUBROUTINE REDO.FC.CL.REGISTER.AA
******************************************************************************
* Company Name:   Asociacion Popular de Ahorros y Prestamos (APAP)
* Developed By:   Regional Temenos Application Management
*-----------------------------------------------------------------------------
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :  Registra los saldos de garantias REDO.FC.CL.BALANCE
*
* Incoming        :  NA
* Outgoing        :  NA
*
*-----------------------------------------------------------------------------
* Modification History:
* ====================
* Development for : APAP
* Development by  : btorresalbornoz@temenos.com
* Date            : 01/06/2011
*
* Development by  : lpazminodiaz@temenos.com
* Date            : 23/08/2011
* Purpose         : Minor ajustments to adapt it to the new template
*
* Edited by       : jvalarezoulloa@temenos.com
* Date            : 20/01/2012
* Purpose         : Change to calcule Avail amount of Collateral for Collaterals types 151,152 y 153
*
* Edited by       : Edwin Charles D
* Date            : 10/08/2017
* Purpose         : Proof of warranty reuse / R15 Upgrade issue
* Reference       : PACS00612954
*27-06-2023 Narmadha V Manual R22 Conversion -commented the variable DYN.TO.OFS
******************************************************************************
******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_GTS.COMMON
    COMMON /NS/P.ID.TRX
* PACS00612954 - S
    $INSERT I_RAPID.APP.DEV.COMMON
* PACS00612954 - E
    $INSERT I_F.REDO.FC.LIMIT.AA
    $INSERT I_F.REDO.FC.CL.BALANCE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.APP.MAPPING
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_REDO.FC.COMMON
******************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    GOSUB PROCESS


RETURN

* =========
INITIALISE:
* =========
    FN.REDO.FC.CL.BALANCE = 'F.REDO.FC.CL.BALANCE'
    F.REDO.FC.CL.BALANCE  = ''
    R.REDO.FC.CL.BALANCE  = ''

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL  = ''
    R.COLLATERAL  = ''

    FN.REDO.APP.MAPPING = 'F.REDO.APP.MAPPING'
    F.REDO.APP.MAPPING = ''
    R.REDO.APP.MAPPING = ''

    FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
    F.REDO.FC.PROD.COLL.POLICY = ''
    R.REDO.FC.PROD.COLL.POLICY = ''

    Y.RECORD.ID = ''
    Y.CL.CODE   = ''
    Y.TYPE.COLL = ''
    Y.TOT.COLL.SD = ''

    Y.COLL.NEW.SD  = ''
    Y.COLL.NEW.VMP = ''
    Y.COLL.NEW.ID  = ''
    Y.COLL.NEW.TYPE = ''
    Y.COLL.NEW.NV  = ''

    MG.ACTUAL = ''
    SALDO.DIS = ''

    Y.VER.COLLATERAL = 'APAP.NOACC'
    Y.APPLICATION    = ''

    FN.RCA.R.NEW = 'F.RCA.R.NEW'
    F.RCA.R.NEW = ''

    Y.AVAIL.VAL.FIELD.NO = ''


    LOC.REF.APPLICATION = 'AA.ARRANGEMENT.ACTIVITY': @FM :'AA.PRD.CAT.TERM.AMOUNT':@FM:'COLLATERAL'
    LOC.REF.FIELDS = 'TXN.REF.ID': @FM : 'L.AA.RISK.PER':@FM:'L.COL.VAL.AVA':@VM:'L.AC.LK.COL.ID'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    TXN.REF.ID.POS = LOC.REF.POS<1,1>
    Y.L.AA.RISK.PER = LOC.REF.POS<2,1>
    Y.AVAIL.VAL.FIELD.NO = LOC.REF.POS<3,1>
    Y.COL.AA.ID = LOC.REF.POS<3,2>

    Y.TXN.ID = R.NEW(AA.ARR.ACT.LOCAL.REF)<1,TXN.REF.ID.POS>
*    Y.TXN.ID =P.ID.TRX
*    IF Y.TXN.ID EQ P.ID.TRX THEN
*        DEBUG
*    END
    MAINT.COLL.ID.EXTRA.CHECK=''
    DI.COL.FLAG = "1"
    Y.AVA.BAL = ''
RETURN

* =========
OPEN.FILES:
* =========
    CALL OPF(FN.REDO.FC.PROD.COLL.POLICY,F.REDO.FC.PROD.COLL.POLICY)
    CALL OPF(FN.REDO.APP.MAPPING,F.REDO.APP.MAPPING)
    CALL OPF(FN.REDO.FC.CL.BALANCE,F.REDO.FC.CL.BALANCE)
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.RCA.R.NEW, F.RCA.R.NEW)

RETURN

* ======================
GET.AA.DATA:
* ======================
    CALL F.READ(FN.RCA.R.NEW, Y.TXN.ID, R.RCA, F.RCA.R.NEW, Y.ERR)
    IF R.RCA THEN
        Y.AA.ID = R.RCA<REDO.FC.ID.ARRANGEMENT>
        Y.AA.AMOUNT  = R.RCA<REDO.FC.AMOUNT>      ;*Loan Amount
        Y.AA.BALANCE = R.RCA<REDO.FC.DIS.AMT.TOT> ;* Amount Disbursed
        Y.AA.COLL.RIGHT = R.RCA<REDO.FC.ID.COLLATERL.RIGHT> ;* Collateral right ID
        Y.AA.LIMIT = R.RCA<REDO.FC.LIMIT.REFERENCE><1,1>    ;*Limit ID
        Y.PRODUCT = R.RCA<REDO.FC.PRODUCT>        ;*Product
        Y.LIMIT.COT.FILE = R.RCA<REDO.FC.ID.LIMIT>
        Y.CUSTOMER = R.RCA<REDO.FC.CUSTOMER>      ;* Customer ID
        Y.AA.AMOUNT.REG = Y.AA.AMOUNT
    END

RETURN

* ======
PROCESS:
* ======

    GOSUB GET.AA.DATA
    GOSUB GET.COLL.CODE

    GOSUB GET.SD.COLL

    Y.COUNT = DCOUNT(Y.TOT.COLL.SD,@VM)
* Itera todos los COLLATERAL asociados
    FOR Y.I = 1 TO Y.COUNT
* Si es que una sola garantia cubre la totalidad del AA

        IF Y.TOT.COLL.SD<1,Y.I> GE Y.AA.AMOUNT  THEN
            MG.ACTUAL<1,Y.I> = Y.AA.AMOUNT
* PACS00350509 - 2014JUN21 - S
            Y.AVA.BAL = Y.TOT.COLL.SD<1,Y.I> - Y.AA.AMOUNT
            CALL SC.FORMAT.CCY.AMT(LCCY,Y.AVA.BAL)
            SALDO.DIS<1,Y.I> = Y.AVA.BAL
* PACS00350509 - 2014JUN21 - E
            GOSUB CHECK.DATA
            GOSUB REGISTER.CL.BALANCE
            GOSUB UPDATE.COLLATERAL
* Instead of using BREAK
            Y.I = Y.COUNT + 1
        END ELSE
            Y.AA.AMOUNT = Y.AA.AMOUNT - Y.TOT.COLL.SD<1,Y.I>
            MG.ACTUAL<1,Y.I> = Y.TOT.COLL.SD<1,Y.I>
* PACS00350509 - 2014JUN21 - S
            Y.AVA.BAL = Y.TOT.COLL.SD<1,Y.I> - MG.ACTUAL<1,Y.I>
            CALL SC.FORMAT.CCY.AMT(LCCY,Y.AVA.BAL)
            SALDO.DIS<1,Y.I> = Y.AVA.BAL
* PACS00350509 - 2014JUN21 - E
            GOSUB UPDATE.COLLATERAL
        END
    NEXT Y.I
    GOSUB REGISTER.CL.BALANCE

RETURN

* ==================
REGISTER.CL.BALANCE:
* ==================
    Y.COUNT.SD = DCOUNT(MAINT.COLL.ID.EXTRA.CHECK,@VM)

* Inicializa Montos
    FOR Y.I.SD = 1 TO Y.COUNT.SD
        IF MG.ACTUAL<1,Y.I.SD> EQ '' THEN
            MG.ACTUAL<1,Y.I.SD> = 0
        END
    NEXT Y.I.SD
    Y.BALANCE.ERR.MSJ = ""
    CALL F.READ(FN.REDO.FC.CL.BALANCE,Y.AA.ID,R.REDO.FC.CL.BALANCE,F.REDO.FC.CL.BALANCE,Y.BALANCE.ERR.MSJ)

    R.REDO.FC.CL.BALANCE<FC.CL.AA.AMOUNT>        = Y.AA.AMOUNT.REG
    R.REDO.FC.CL.BALANCE<FC.CL.AA.BALANCE>       = Y.AA.BALANCE
    R.REDO.FC.CL.BALANCE<FC.CL.COLLATERAL.RIGHT> = MAINT.COLL.ID.EXTRA.CHECK
    R.REDO.FC.CL.BALANCE<FC.CL.COLLATERAL.ID>    = Y.COLL.NEW.ID
    R.REDO.FC.CL.BALANCE<FC.CL.MG.ACTUAL>        = MG.ACTUAL
    R.REDO.FC.CL.BALANCE<FC.CL.MG.ORIGINAL>      = MG.ACTUAL
    IF PGM.VERSION EQ ',AA.NEW.FC' THEN
        R.REDO.FC.CL.BALANCE<FC.CL.MG.ACTUAL>        = Y.AA.AMOUNT.REG
        R.REDO.FC.CL.BALANCE<FC.CL.MG.ORIGINAL>      = Y.AA.BALANCE
    END
    CALL F.WRITE(FN.REDO.FC.CL.BALANCE,Y.AA.ID,R.REDO.FC.CL.BALANCE)


    GOSUB UPDATE.CONCAT

RETURN

* ============
UPDATE.CONCAT:
* ============
    Y.LIMIT.ID.COT.FILE = FMT(Y.LIMIT.COT.FILE,"10'0'R")
    Y.AA.LIMIT = Y.CUSTOMER:".":Y.LIMIT.ID.COT.FILE

    FN.REDO.FC.LIMIT.AA = "F.REDO.FC.LIMIT.AA"    ;* Nombre concat file
    CALL CONCAT.FILE.UPDATE(FN.REDO.FC.LIMIT.AA,Y.AA.LIMIT,Y.AA.ID,'I','AR')

RETURN

* ================
UPDATE.COLLATERAL:
* ================
    COLL.FLAG = '1'
    Y.APPLICATION = 'COLLATERAL'

    Y.COUNT.C = DCOUNT(Y.COLL.NEW.ID,@VM)
    R.COLLATERAL.MSG = ''


    CALL F.READ(FN.COLLATERAL,Y.COLL.NEW.ID<1,Y.I>,R.COLLATERAL,F.COLLATERAL,ERR.MS)

    IF ERR.MS THEN
        ETEXT = "EB-FC-READ.ERROR"
        CALL STORE.END.ERROR
    END ELSE
        IF SALDO.DIS<1,Y.I> EQ '' THEN
            SALDO.DIS<1,Y.I> = 0.00
        END
    END


    Y.FIELD.FROM = 'LOCAL.REF'
    CALL EB.FIND.FIELD.NO(Y.APPLICATION,Y.FIELD.FROM)
    Y.AVAIL.BAL = SALDO.DIS<1,Y.I>
    ID.COLL     = Y.COLL.NEW.ID<1,Y.I>
    R.COLLATERAL.MSG<Y.FIELD.FROM,Y.AVAIL.VAL.FIELD.NO> = Y.AVAIL.BAL
    Y.RES = INDEX(R.COLLATERAL<Y.FIELD.FROM,Y.COL.AA.ID>, Y.AA.ID, 1)
    IF Y.RES EQ 0 THEN
        R.COLLATERAL<Y.FIELD.FROM,Y.COL.AA.ID,-1> =  Y.AA.ID
        R.COLLATERAL.MSG<Y.FIELD.FROM,Y.COL.AA.ID> = R.COLLATERAL<Y.FIELD.FROM,Y.COL.AA.ID>
    END
    OFS.INFO.INPUT = ''

    OFS.INFO.INPUT<1,1> = Y.VER.COLLATERAL
    OFS.INFO.INPUT<1,2> = 'I'
    OFS.INFO.INPUT<2,1> = 'PROCESS'
    OFS.INFO.INPUT<2,6> = '0'
    OFS.INFO.INPUT<2,4> = ID.COLL

*    Y.OFS.MSG.REQ = DYN.TO.OFS(R.COLLATERAL.MSG, Y.APPLICATION, OFS.INFO.INPUT); *Manual R22 Converion

* Process OFS Message
* Y.OFS.MESSAGE = Y.OFS.MSG.REQ;*Manual R22 Conversion
    OFS.SRC = 'FC.OFS'
    OFS.MSG.ID = ""
    OPTIONS = ""
    CALL OFS.POST.MESSAGE(Y.OFS.MESSAGE,OFS.MSG.ID,OFS.SRC,OPTIONS)


RETURN

* ===========
CHECK.PROCESS:
* ===========
    IF E NE '' THEN
        PROCESS.ERR = 1
    END ELSE
        PROCESS.ERR = 0
    END
RETURN

*=============
GET.COLL.CODE:
*=============
    CALL CACHE.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.PRODUCT, R.REDO.FC.PROD.COLL.POLICY, YERR)
    Y.TYPES.CODES = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>

* Titulos Publicos
    LOCATE 100 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 100
            END ELSE
                Y.TYPE.COLL = 100
            END
            YPOS = ''
        END
    END

* Depositos Internos
    LOCATE 150 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 150
            END ELSE
                Y.TYPE.COLL = 150
            END
            YPOS = ''
        END
    END

* Depositos Externos
    LOCATE 200 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 200
            END ELSE
                Y.TYPE.COLL = 200
            END
            YPOS = ''
        END
    END

* Vehiculos
    LOCATE 350 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 350
            END ELSE
                Y.TYPE.COLL = 350
            END
            YPOS = ''
        END
    END

* Bienes Raices
    LOCATE 450 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 450
            END ELSE
                Y.TYPE.COLL = 450
            END
            YPOS = ''
        END
    END

* Firmas Solidarias
    LOCATE 970 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 970
            END ELSE
                Y.TYPE.COLL = 970
            END
            YPOS = ''
        END
    END

RETURN

* =========
GET.SD.COLL:
* =========

    Y.COUNT.C.U = DCOUNT(Y.TYPE.COLL,@VM)
    FOR Y.C.U = 1 TO Y.COUNT.C.U
        REDO.APP.MAPPING.ID = 'CC-' : Y.TYPE.COLL<1,Y.C.U>
        CALL F.READ(FN.REDO.APP.MAPPING,REDO.APP.MAPPING.ID, R.REDO.APP.MAPPING,F.REDO.APP.MAPPING, Y.ERR)
        Y.COLL.NEW.VMP = ''
        Y.COLL.NEW.SD  = ''
        Y.COLL.NEW.TYPE = ''
        Y.COLL.NEW.NV  = ''
        IF R.REDO.APP.MAPPING THEN
            Y.MAPP.FILED  = R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>
            Y.APPLICATION = FIELD(R.REDO.APP.MAPPING<REDO.APP.APP.FROM>,@VM,1)

* Valor Disponible de la Garantia
            LOCATE "L.COL.VAL.AVA" IN Y.MAPP.FILED<1,1> SETTING ZPOS THEN
                Y.NAME.FIELD.SD  = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM,ZPOS)
                CALL EB.FIND.FIELD.NO(Y.APPLICATION, Y.NAME.FIELD.SD)
                Y.COLL.NEW.SD  =  R.RCA<Y.NAME.FIELD.SD>    ;*extract values field saldo Disponible de la Garantia
            END

* Monto Maximo a Prestar
            LOCATE "L.COL.LN.MX.VAL" IN Y.MAPP.FILED<1,1> SETTING ZPOS THEN
                Y.NAME.FIELD.MVP = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM,ZPOS)
                CALL EB.FIND.FIELD.NO(Y.APPLICATION, Y.NAME.FIELD.MVP)
                Y.COLL.NEW.VMP = R.RCA<Y.NAME.FIELD.MVP>    ;*extract values of field Valor Maximo a Prestar
            END

*ADD FOR PAC PACS00169926 the way to calculate avail amount for DIs collateral  is different
            LOCATE "COLLATERAL.TYPE" IN Y.MAPP.FILED<1,1> SETTING ZPOS THEN
                Y.NAME.FIELD.COLL.TYPE = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM,ZPOS)
                CALL EB.FIND.FIELD.NO(Y.APPLICATION, Y.NAME.FIELD.COLL.TYPE)
                Y.COLL.NEW.TYPE = R.RCA<Y.NAME.FIELD.COLL.TYPE>       ;*extract values of field types of collaterals
            END

*ADD FOR PAC PACS00169926 to get Nominal value of collaterals
            LOCATE "NOMINAL.VALUE" IN Y.MAPP.FILED<1,1> SETTING ZPOS THEN
                Y.NAME.FIELD.COLL.NV = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM,ZPOS)
                CALL EB.FIND.FIELD.NO(Y.APPLICATION, Y.NAME.FIELD.COLL.NV)
                Y.COLL.NEW.NV = R.RCA<Y.NAME.FIELD.COLL.NV> ;*extract values of field nominal amt of collaterals
            END
            GOSUB GET.COLLATERAL.ID
            GOSUB CALC.TOTAL.VALUES
        END
    NEXT Y.C.U

RETURN

* ===============
CALC.TOTAL.VALUES:
* ===============
    Y.COUNT.C = DCOUNT(Y.COLL.NEW.VMP,@VM)
* Through all the Collaterals associated
    FOR Y.C = 1 TO Y.COUNT.C
        GOSUB DI.COLL.SD.CALC
*If collateral has Saldo Disponible and has Valor Maximo a Prestar
        IF Y.COLL.NEW.VMP<1,Y.C> NE '' AND Y.COLL.NEW.SD<1,Y.C> NE '' THEN
            IF Y.TOT.COLL.SD NE '' THEN
                Y.TOT.COLL.SD := @VM : Y.COLL.NEW.SD<1,Y.C>
            END ELSE
                Y.TOT.COLL.SD = Y.COLL.NEW.SD<1,Y.C>
            END
        END
* If collateral doesnt have Saldo Disponible and has Valor Maximo a Prestar
        IF Y.COLL.NEW.VMP<1,Y.C> NE '' AND Y.COLL.NEW.SD<1,Y.C> EQ '' AND DI.COL.FLAG THEN
            IF Y.TOT.COLL.SD NE '' THEN
                Y.TOT.COLL.SD := @VM : Y.COLL.NEW.VMP<1,Y.C>
            END ELSE
                Y.TOT.COLL.SD = Y.COLL.NEW.VMP<1,Y.C>
            END
        END

    NEXT Y.C
RETURN

* ===============
GET.COLLATERAL.ID:
* ===============
* Collateral ID
    LOCATE "@ID" IN Y.MAPP.FILED<1,1> SETTING ZPOS THEN
        Y.NAME.FIELD.COLL.ID  = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM,ZPOS)
        CALL EB.FIND.FIELD.NO(Y.APPLICATION, Y.NAME.FIELD.COLL.ID)
        Y.CL.ID = R.RCA<Y.NAME.FIELD.COLL.ID>

        IF Y.CL.ID NE '' THEN
            IF Y.COLL.NEW.ID EQ '' THEN
                Y.COLL.NEW.ID = Y.CL.ID
            END ELSE
                Y.COLL.NEW.ID := @VM : Y.CL.ID
            END
        END
    END

RETURN

* =========
CHECK.DATA:
* =========
    MAINT.COLL.ID.EXTRA.ORDEN = Y.COLL.NEW.ID
    Y.COUNT.C = DCOUNT(MAINT.COLL.ID.EXTRA.ORDEN,@VM)
    FOR Y.C = 1 TO Y.COUNT.C

        VAR.IZQ=FIELD(MAINT.COLL.ID.EXTRA.ORDEN<1,Y.C>,".",1)
        VAR.MDE=FIELD(MAINT.COLL.ID.EXTRA.ORDEN<1,Y.C>,".",2)
        VAR.COLL.ID=VAR.IZQ:".":VAR.MDE
        IF MAINT.COLL.ID.EXTRA.CHECK  THEN
            MAINT.COLL.ID.EXTRA.CHECK := @VM : VAR.COLL.ID
        END ELSE
            MAINT.COLL.ID.EXTRA.CHECK = VAR.COLL.ID
        END

    NEXT Y.C
RETURN

*================
DI.COLL.SD.CALC:
*================
    DI.COL.FLAG = 1
    Y.TOT.NV = SUM (Y.COLL.NEW.NV)
    Y.RISK = 100
    IF Y.TOT.NV GT Y.AA.AMOUNT THEN
        Y.RISK = (Y.TOT.NV * 100) / Y.AA.AMOUNT
        CALL SC.FORMAT.CCY.AMT(LCCY,Y.RISK)
    END

    IF Y.COLL.NEW.VMP<1,Y.C> AND NOT(Y.COLL.NEW.SD<1,Y.C>) AND ( Y.COLL.NEW.TYPE<1,Y.C> EQ 151 OR Y.COLL.NEW.TYPE<1,Y.C> EQ 152 OR Y.COLL.NEW.TYPE<1,Y.C> EQ 153) THEN
        DI.COL.FLAG = ""
        Y.COLL.SD  = 0
        Y.COLL.SD = (Y.COLL.NEW.NV<1,Y.C> * 100) / Y.RISK
        CALL SC.FORMAT.CCY.AMT(LCCY,Y.COLL.SD)
* PACS00393917 - S
*        IF Y.COLL.NEW.VMP<1,Y.C> GE Y.AA.AMOUNT THEN
*            GOSUB COLL.COVERS
*        END
*
*        IF Y.COLL.NEW.VMP<1,Y.C> < Y.AA.AMOUNT THEN
*            GOSUB COLL.NOT.COVER
*        END
* PACS00393917 - E
* PACS00393917 - 2014SEP18 - S
        IF Y.TOT.COLL.SD NE '' THEN
            Y.TOT.COLL.SD := @VM : Y.COLL.SD
        END ELSE
            Y.TOT.COLL.SD = Y.COLL.SD
        END
* PACS00393917 - 2014SEP18 - E

    END

RETURN

END
