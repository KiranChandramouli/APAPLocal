* @ValidationCode : MjoxMTgzNDQ2NzE0OkNwMTI1MjoxNjgwNzgzNjY3MjkxOklUU1M6LTE6LTE6NTU3OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:51:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 557
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.COLL.FS.HF
*=============================================================================
* Subroutine Type : ROUTINE
* Attached to     : VERSION REDO.CREATE.ARRANGEMENT.FS
* Attached as     : HOT FIELD - ROUTINE
* Primary Purpose : VALIDATION TO COLLATERAL FIRMAS SOLIDARIAS
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*=============================================================================
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : MG - TAM Latin America
* Date            : DEC 03, 2012
*
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*=============================================================================

******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.COLLATERAL.CODE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.USER

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.COLLATERAL.REA
    $INSERT I_GTS.COMMON


******************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* ======
PROCESS:
* ======
    IF OFS$HOT.FIELD THEN
        GUAR.CUS.ID = COMI
        R.NEW(REDO.FC.GUARAN.ID.FS)<1,AV> = COMI
    END  ELSE
        RETURN
    END

    GOSUB ID.GARANTE
    GOSUB TIPO.GARANTE.SOLIDARIO

RETURN
* =========
ID.GARANTE:
* =========


    R.NEW(REDO.FC.LOAN.DEBTOR.ID.FS)<1,AV> = R.NEW(REDO.FC.CUSTOMER)
    LOAN.DEBTORS.ID = R.NEW(REDO.FC.LOAN.DEBTOR.ID.FS)<1,AV>

    IF LOAN.DEBTORS.ID THEN
        CALL F.READ(FN.CUSTOMER,LOAN.DEBTORS.ID,R.CUSTOMER,F.CUSTOMER,Y.CUSTOMER.ERR.MSJ)
        IF Y.CUSTOMER.ERR.MSJ THEN
            ETEXT = "EB-FC-READ.ERROR" : @FM : FN.CUSTOMER
            CALL STORE.END.ERROR
        END ELSE
            VAL.CUS.NAME.LOAN = R.CUSTOMER<EB.CUS.NAME.1>
            VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LEGAL.ID>

            Y.CURRENT.L.ID = VAL.LEGAL.ID.LOAN
            GOSUB PROCESS.CUS.LEGAL.ID

            R.NEW(REDO.FC.LOAN.DEB.NAME.FS)<1,AV>=VAL.CUS.NAME.LOAN
            R.NEW(REDO.FC.LOAN.DEB.LEG.ID.FS)<1,AV>=Y.CURRENT.L.ID
        END
    END
    Y.CURRENT.L.ID = ''

    IF GUAR.CUS.ID THEN
        CALL F.READ(FN.CUSTOMER,GUAR.CUS.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.GUAR.ERR.MSJ)
        IF Y.CUS.GUAR.ERR.MSJ THEN
            ETEXT = "EB-FC-READ.ERROR" : @FM : FN.CUSTOMER
            CALL STORE.END.ERROR
        END ELSE
            VAL.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1>
            VAL.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID>

            Y.CURRENT.L.ID = VAL.LEGAL.ID
            GOSUB PROCESS.CUS.LEGAL.ID


            R.NEW(REDO.FC.GUARAN.NAME.FS)<1,AV>= VAL.CUS.NAME
            R.NEW(REDO.FC.GUARAN.LEGAL.ID.FS)<1,AV> = Y.CURRENT.L.ID
        END
    END

    IF GUAR.CUS.ID EQ LOAN.DEBTORS.ID THEN
        AF = REDO.FC.GUARAN.ID.FS
        AV = AV
        ETEXT = 'EB-FC-GUAR-SAME-DEU'
        CALL STORE.END.ERROR
    END

RETURN

* =========
PROCESS.CUS.LEGAL.ID:
* =========
    IF NOT(Y.CURRENT.L.ID) THEN
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSLCUCI> THEN
            Y.CURRENT.L.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSLCUCI>
            RETURN
        END
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSLCUPASS> THEN
            Y.CURRENT.L.ID  = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSLCUPASS>
        END
        RETURN
    END

RETURN

* =====================
TIPO.GARANTE.SOLIDARIO:
* =====================
    IF GUAR.CUS.ID<1,AV> THEN
        CALL F.READ(FN.CUSTOMER,GUAR.CUS.ID<1,AV>,R.CUSTOMER,F.CUSTOMER,Y.GUR.CUS.ERR.MSJ)
        IF Y.GUR.CUS.ERR.MSJ THEN
            ETEXT = "EB-FC-READ.ERROR" : @FM : FN.CUSTOMER
            CALL STORE.END.ERROR
        END ELSE
            VAL.CUS.NA= R.CUSTOMER<EB.CUS.NATIONALITY>
            VAL.CUS.TYPE= R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSLCU>
            VAL.CUS.LEGA.ID= R.CUSTOMER<EB.CUS.LEGAL.ID>
            BEGIN CASE
                CASE VAL.CUS.TYPE  EQ "PERSONA FISICA" AND VAL.CUS.NA EQ "DO" AND NOT(R.NEW(REDO.FC.GUARAN.LEGAL.ID.FS))
                    R.NEW(REDO.FC.TYPE.JOINT.GUAR.FS)<1,AV>= "P3"
                CASE VAL.CUS.TYPE  EQ "PERSONA FISICA" AND VAL.CUS.NA EQ "DO"
                    R.NEW(REDO.FC.TYPE.JOINT.GUAR.FS)<1,AV>= "P1"
                CASE VAL.CUS.TYPE  EQ "PERSONA FISICA" AND VAL.CUS.NA NE "DO"
                    R.NEW(REDO.FC.TYPE.JOINT.GUAR.FS)<1,AV>= "P2"
                CASE VAL.CUS.TYPE  EQ "PERSONA JURIDICA"
                    R.NEW(REDO.FC.TYPE.JOINT.GUAR.FS)<1,AV>= "E3"
            END CASE
        END
    END
RETURN


* =========
OPEN.FILES:
* =========
    CALL OPF(FN.USR,F.USR)
    CALL OPF(FN.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

* =========
INITIALISE:
* =========

    WCAMPOU = "VAL.MOD.DATE"    ;*Set the field validate user date
    WCAMP = "L.CU.TIPO.CL"
    WCAMP<2> = "L.CU.CIDENT"
    WCAMP<3> = "L.CU.PASS.NAT"
    WCAMPO  = "L.COL.SEC.HOLD"
    WCAMPO<2> = "L.COL.GT.DATE"
    WCAMPO<3> = "L.COL.EXE.DATE"
    WCAMPO<4> = "L.COL.VAL.AVA"
    WCAMPO<5> = "L.COL.DEBTOR.ID"
    WCAMPO<6> = "L.COL.DEBTOR.NA"
    WCAMPO<7> = "L.COL.DBR.LEGID"
    WCAMPO<8> = "L.COL.GUAR.ID"
    WCAMPO<9> = "L.COL.GUAR.NAME"
    WCAMPO<10> = "L.COL.GUR.LEGID"
    WCAMPO<11> = "L.COL.GUAR.TYPE"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    WCAMP = CHANGE(WCAMP,@FM,@VM)
    WCAMPO = WCAMPO : @FM : WCAMPOU : @FM : WCAMP
    Y.APP = "COLLATERAL" : @FM : "USER" : @FM : "CUSTOMER"
    ZPOS = ''
    CALL MULTI.GET.LOC.REF(Y.APP,WCAMPO,ZPOS)
    WPOSSECH = ZPOS<1,1>
    WPOSGTDATA = ZPOS<1,2>
    WPOSEXEDATE = ZPOS<1,3>
    WPOSAVAIL = ZPOS<1,4>
    WPOSDEBTORID = ZPOS<1,5>
    WPOSDEBTORNAME = ZPOS<1,6>
    WPOSDEBTORLEGID = ZPOS<1,7>
    WPOSGUARID = ZPOS<1,8>
    WPOSGUARNAME = ZPOS<1,9>
    WPOSGUARLEGID = ZPOS<1,10>
    WPOSGUARTYPE = ZPOS<1,11>
    WPOSUSER     = ZPOS<2,1>
    WPOSLCU      = ZPOS<3,1>
    WPOSLCUCI    = ZPOS<3,2>
    WPOSLCUPASS    = ZPOS<3,3>

    Y.SEC.NO = R.NEW(REDO.FC.SEC.NO.STATE.TP)

    Y.CUS.GAR.LEGAL.ID = ''
    Y.CUS.DEU.LEGAL.ID = ''

    FN.COLLATERAL= "F.COLLATERAL"
    F.COLLATERAL=""

    FN.COLLATERAL.CODE= "F.COLLATERAL.CODE"
    F.COLLATERAL.CODE=""

    FN.CUSTOMER= "F.CUSTOMER"
    F.CUSTOMER=""

    FN.USR  = 'F.USER'
    F.USR   = ''
    R.USR   = ''

    FN.CUSTOMER= "F.CUSTOMER"
    F.CUSTOMER=""

    Y.COLLATERAL.TYPE = R.NEW(REDO.FC.SEC.CLASSIFY.FS)
    Y.VALUE.DATE = R.NEW(REDO.FC.SEC.CREATE.DATE.FS)
    Y.NOMINAL.VALUE = R.NEW(REDO.FC.SEC.VALUE.FS)

    Y.CENTRAL.BANK.VALUE = ''

    FN.REDO.COLLATERAL.REA = 'F.REDO.COLLATERAL.REA'
    F.REDO.COLLATERAL.REA = ''
    R.REDO.COLLATERAL.REA = ''
    Y.REDO.COLLATERAL.REA.ID = Y.COLLATERAL.TYPE
    Y.ERR.REDO.COLLATERAL.REA = ''

    Y.COLL.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.FS)

RETURN

END
