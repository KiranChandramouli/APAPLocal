*-----------------------------------------------------------------------------
* <Rating>-116</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.CREATE.ARRANGEMENT.A.INS(RESULT)
*-----------------------------------------------------------------------------
* Developer    : MGUDINO (mgudino@temenos.com)
* Date         : 16.06.2011
* Description  : Create OFS message and execute for POLICY aplications
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date        Who         Reference     Description
* 1.0       13.07.2011  mgudino     CR.180        Initial Version
* 1.1       06.09.2011  lpazmino    CR.180        Capture Overrides
* 1.2       13.07.2011  mgudino     CR.180        Ammend ASOCIATED.LOAN FILED
*-----------------------------------------------------------------------------
* Input/Output: N/A
* Dependencies: N/A
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON

    $INSERT RAD.BP I_RAPID.APP.DEV.COMMON

    $INSERT I_F.APAP.H.INSURANCE.DETAILS

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.APP.MAPPING
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
* </region>


    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN

* <region name="INIT" description="Initialise">
INIT:
    Y.APPLICATION = ''

    Y.VER.INSURANCE = "REDO.FC"

    Y.OFS.MSG.REQ = ''
    Y.OFS.MSG.RES = ''
    PROCESS.ERR = ''

    Y.PRODUCT       = ''
    Y.NUM.CL.CODES  = ''
    Y.NUM.CL.FIELDS = ''

    FN.REDO.APP.MAPPING = 'F.REDO.APP.MAPPING'
    F.REDO.APP.MAPPING  = ''
    R.REDO.APP.MAPPING  = ''

    FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
    F.REDO.FC.PROD.COLL.POLICY  = ''
    R.REDO.FC.PROD.COLL.POLICY  = ''

    FN.COLLATERAL = ''
    F.COLLATERAL  = ''
    R.COLLATERAL  = ''

    R.COLL.RIGHT.MSG = ''
    R.INSURANCE.MSG = ''

    Y.ERR = ''

    Y.COLL.SEQ = ''

    Y.CL.FIELD.ID = ''
    Y.CL.ID = ''
    Y.INS.ID = ''

    E = ''

    RETURN
* </region>

* <region name="OPEN.FILES" description="Open Files">
OPEN.FILES:
    CALL OPF(FN.REDO.APP.MAPPING, F.REDO.APP.MAPPING)
    CALL OPF(FN.REDO.FC.PROD.COLL.POLICY,F.REDO.FC.PROD.COLL.POLICY)

    RETURN
* </region>

* <region name="PROCESS" description="Main Process">
PROCESS:
    GOSUB GET.INS.FIELDS.VALUES
    IF PROCESS.ERR THEN
        RESULT = 'FAIL'
    END ELSE
        RESULT = 'OK'
    END
    RETURN
* </region>

* <region name="GET.INS.FIELDS.VALUES" description="Get the Insurance values from the R.NEW, follow the Params">
GET.INS.FIELDS.VALUES:
    Y.PRODUCT   = R.NEW(REDO.FC.PRODUCT)
    Y.RECORD.ID = ''
    Y.CL.CODE   = ''

    GOSUB GET.INS.TO.PROCESS
* Itera por cada MV que hayan ingresado
    K =1
    LOOP
    WHILE K LE Y.NUM.CL.REC
* Recorre todos los campos
        J =1
        LOOP
        WHILE J LE Y.NUM.CL.FIELDS
* init variables
            Y.FIELD.TO   = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>,VM,J)
            Y.FIELD.FROM = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,VM,J)
            Y.CAPTURE.CL.CODE = 0

            CALL EB.FIND.FIELD.NO(Y.APP.FROM,Y.FIELD.FROM)
            IF Y.FIELD.TO EQ '@ID' THEN
                Y.INS.ID = R.NEW(Y.FIELD.FROM)<1,K>
            END

            IF Y.FIELD.TO EQ 'ID.TEMPORAL' THEN
                GOSUB INCLUDE.COLL
            END

            GOSUB SET.CL.FIELD
            J+=1
        REPEAT

* Send OFS message
        GOSUB PROCESS.INSURANCE.OFS
        R.INSURANCE.MSG = ''
        K+=1
    REPEAT

    RETURN
* </region>

INCLUDE.COLL:
* Search, If the Insurance has relation with Collateral Code.

    Y.COLLATERA.ID = ''
    Y.POLICY.ID = R.NEW(Y.FIELD.FROM)<1,K>
    IF R.NEW(REDO.FC.SEC.NO.STATE.BR) THEN
        Y.CONT.COLL = DCOUNT(R.NEW(REDO.FC.SEC.NO.STATE.BR), VM)
        FOR Y.COLL = 1 TO Y.CONT.COLL
            LOCATE Y.POLICY.ID IN R.NEW(REDO.FC.INSUR.POLICY.BR)<1,Y.COLL,1> SETTING POS.COLL.ID THEN
                Y.COLLATERA.ID  = R.NEW(REDO.FC.SEC.NO.STATE.BR)<1,Y.COLL>
            END
        NEXT Y.COLL
        R.INSURANCE.MSG<INS.DET.COLLATERAL.ID> = Y.COLLATERA.ID
    END
    IF R.NEW(REDO.FC.SEC.NO.STATE.VS) THEN
        Y.CONT.COLL = DCOUNT(R.NEW(REDO.FC.SEC.NO.STATE.VS), VM)
        FOR Y.COLL = 1 TO Y.CONT.COLL
            LOCATE Y.POLICY.ID IN R.NEW(REDO.FC.INSUR.POLICY.VS)<1,Y.COLL,1> SETTING POS.COLL.ID THEN
                Y.COLLATERA.ID  = R.NEW(REDO.FC.SEC.NO.STATE.VS)<1,Y.COLL>
            END
        NEXT Y.COLL
        R.INSURANCE.MSG<INS.DET.COLLATERAL.ID> = Y.COLLATERA.ID
    END
    RETURN


* <region name="PROCESS.INSURANCE.OFS" description="Process the OFS messages for COLLATERAL and COLLATERAL.RIGHT">
PROCESS.INSURANCE.OFS:

************************************
* Build INSURANCE OFS MESSAGE
************************************
    Y.APPLICATION = 'APAP.H.INSURANCE.DETAILS'

    OFS.INFO.INPUT = ''
    OFS.INFO.INPUT<1,1> = Y.VER.INSURANCE
    OFS.INFO.INPUT<1,2> = 'I'
    OFS.INFO.INPUT<2,1> = 'PROCESS'
    OFS.INFO.INPUT<2,6> = '1'
    OFS.INFO.INPUT<2,4> = Y.INS.ID

* Setear los datos del Collateral Right, una vez generados
    Y.OFS.MSG.REQ = DYN.TO.OFS(R.INSURANCE.MSG, Y.APPLICATION, OFS.INFO.INPUT)

* Process OFS Message
    CALL REDO.UTIL.PROCESS.OFS(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
    GOSUB CHECK.PROCESS
    IF PROCESS.ERR THEN
        RETURN
    END

* Capture overrides
    R.INS.RES = OFS.TO.DYN(Y.OFS.MSG.RES,Y.APPLICATION,Y.OFS.INFO)
    IF R.INS.RES<INS.DET.OVERRIDE> NE '' THEN
        Y.OVERRIDE.MSG = Y.APPLICATION : ' - ' : R.INS.RES<INS.DET.OVERRIDE>
        R.NEW(REDO.FC.OVERRIDE) = R.NEW(REDO.FC.OVERRIDE) : VM : Y.OVERRIDE.MSG
    END

    RETURN
* </region>

* <region name="GET.INS.TO.PROCESS" description="Obtain the Collaterals to process">
GET.INS.TO.PROCESS:

* Obtiene los campos que deberia ingresar de acuerdo al COLLATERAL.CODE obtenido
    REDO.APP.MAPPING.ID = 'INSURANCE'
    CALL CACHE.READ(FN.REDO.APP.MAPPING, REDO.APP.MAPPING.ID, R.REDO.APP.MAPPING, Y.ERR)

* Identifica las posiciones de los campos fijos y locales
    Y.NUM.CL.FIELDS = DCOUNT(R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>, VM)

    Y.APP.FROM  = FIELD(R.REDO.APP.MAPPING<REDO.APP.APP.FROM>,VM,1)
    Y.APP.TO = FIELD(R.REDO.APP.MAPPING<REDO.APP.APP.TO>,VM,1)

* Evalua cuantos registros debe crear de ese COLLATERAL.CODE
    Y.FIELD.TO   = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>,VM,2)
    Y.FIELD.FROM = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,VM,2)
    Y.NUM.CL.REC = DCOUNT(R.NEW(REDO.FC.CLASS.POLICY), VM)

    RETURN
* </region>

* <region name="SET.CL.FIELD:" description="Set the COLLATERAL Field">
SET.CL.FIELD:

    Y.NAME = Y.FIELD.TO
    CALL EB.FIND.FIELD.NO(Y.APP.TO, Y.FIELD.TO)

    IF NOT(Y.FIELD.TO) THEN
* Es campo local
* Obtener la posicion de LOCAL.REF
        Y.LOCAL.FIELD = 'LOCAL.REF'
        CALL EB.FIND.FIELD.NO(Y.APP.TO, Y.LOCAL.FIELD)

* Obtener la posicion del campo local
        Y.FIELD = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>,VM,J)
        Y.FIELD.NO = 0
        CALL GET.LOC.REF (Y.APP.TO,Y.FIELD,Y.FIELD.NO)
        Y.FIELD.FROM.VAL = FIELD(R.NEW(Y.FIELD.FROM),VM,K)
        R.INSURANCE.MSG<Y.LOCAL.FIELD,Y.FIELD.NO> = Y.FIELD.FROM.VAL
    END ELSE
* Es campo fijo
*MG18042012, IF IS ASSOCIATED.LOAN, DEPENDS ON HEADER OF RECORD NO INSURANCE.
        IF Y.NAME EQ 'ASSOCIATED.LOAN' THEN
            Y.FIELD.FROM.VAL = FIELD(R.NEW(Y.FIELD.FROM),VM,1)
        END ELSE
            Y.FIELD.FROM.VAL = FIELD(R.NEW(Y.FIELD.FROM),VM,K)
        END
*MG18042012
* Validacion cambio de SM por VM, segun Insurance
        Y.CONT.SM = DCOUNT(Y.FIELD.FROM.VAL, SM)
        IF Y.CONT.SM GT 0 THEN
            CHANGE SM TO VM IN Y.FIELD.FROM.VAL
        END
        R.INSURANCE.MSG<Y.FIELD.TO> = Y.FIELD.FROM.VAL
    END

    RETURN
* </region>

* <region name="CHECK.PROCESS" description="Check Process">
CHECK.PROCESS:
    IF E NE '' THEN
        PROCESS.ERR = 1
    END ELSE
        PROCESS.ERR = 0
    END
    RETURN
* </region>

END
