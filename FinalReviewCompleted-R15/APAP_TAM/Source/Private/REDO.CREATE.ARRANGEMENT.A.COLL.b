* @ValidationCode : MjoxMTgyNzgzNjI5OkNwMTI1MjoxNzAwNDgwNTg1NjY3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Nov 2023 17:13:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CREATE.ARRANGEMENT.A.COLL(RESULT)
*-------------------------------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 16.06.2011
* Description  : Create COLLATERAL.RIGHT - COLLATERAL through FC
*-------------------------------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       15.06.2011      lpazmino          CR.180         Refactoring
* 2.0       06.09.2011      lpazmino          CR.180         Capture overrides
* 3.0       10.11.2011      lpazmino          CR.180         Fixes in Limit Seq. generation
*                                                            to avoid HIS errors.
* 3.1       20.01.2012      jvalarezoulloa    CR.180         Limit Reference on Collateral Right
* 3.2       05.03.2012      jvalarezoulloa    CR.180         Make and exception to mapping field named address that is used on bienes raices
* 3.3       11.04.2012      jvalarezoulloa    CR.180         Set Correct format for Limit Reference
* 3.4       17.05.2012      jvalarezoulloa    CR.180         Avoid that It try to registered LIMIT.REFENCE more than once time
*-------------------------------------------------------------------------------------------------
* Input/Output: NA/RESULT (The result of the transaction)
* Dependencies: N/A
*-------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*28-08-2023    CONVERSION TOOL     R22 AUTO CONVERSION	   INSERT FILE MODIFIED,++ TO +=1, VM TO @VM,SM TO @SM,VARIABLE NAME MODIFIED
*28-08-2023    VICTORIA S          R22 MANUAL CONVERSION   DYN.TO.OFS to OFS.BUILD.RECORD, CALL ROUTINE MODIFIED
*17-11-2023    Santosh             R22 MANUAL CONVERSION   Change as part of For TC-309/314
*----------------------------------------------------------------------------------------
* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON

*   $INSERT I_RAPID.APP.DEV.COMMON ;*R22 MANUAL CONVERSION
*   $INSERT I_RAPID.APP.DEV.EQUATE ;*R22 MANUAL CONVERSION

    $INSERT I_F.COLLATERAL.RIGHT
    $INSERT I_F.COLLATERAL

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.APP.MAPPING
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
    $INSERT I_System
    $USING APAP.LAPAP
*
* </region>

    IF R.NEW(REDO.FC.SECURED) EQ 'SI'  THEN
        GOSUB INIT
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
RETURN
*
* <region name="INIT" description="Initialise">
INIT:
    Y.APPLICATION = ''

    Y.VER.COLL.RIGHT = "APAP"
    Y.VER.COLLATERAL = "APAP"

    Y.OFS.MSG.REQ = ''
    Y.OFS.MSG.RES = ''

    Y.PRODUCT       = ''
    Y.NUM.CL.CODES  = ''
    Y.NUM.CL.FIELDS = ''

    FN.REDO.APP.MAPPING = 'F.REDO.APP.MAPPING'
    F.REDO.APP.MAPPING  = ''
    R.REDO.APP.MAPPING  = ''

    FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
    F.REDO.FC.PROD.COLL.POLICY  = ''
    R.REDO.FC.PROD.COLL.POLICY  = ''

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL  = ''
    R.COLLATERAL  = ''

    FN.COLLATERAL.RIGHT = 'F.COLLATERAL.RIGHT'
    F.COLLATERAL.RIGHT = ''
    R.COLLATERAL.RIGHT = ''

    R.COLL.RIGHT.MSG = ''
    R.COLLATERAL.MSG = ''

    Y.PRODUCT   = R.NEW(REDO.FC.PRODUCT)
    Y.CURRENCY = R.NEW(REDO.FC.LOAN.CURRENCY)

    Y.ERR = ''

    Y.COLL.SEQ = ''

    Y.CL.FIELD.ID = ''
    Y.CL.ID = ''
    Y.CR.ID = ''

    Y.COLLR = ''
    E = ''

    Y.CUSTOMER.FLD.POS = ''
    Y.CUSTOMER.FLD.NAME = ''
    Y.CUSTOMER.FLD.PREFIX = ''
*JV05032012
    Y.FIELD.FROM.T = ""
    Y.ADDRES.BR = ""
* PACS00273344 - S
    Y.LR.STATUS  = "CUR"
    Y.LR.ST.NAME = "L.CR.ESTADO"
    CALL GET.LOC.REF("COLLATERAL.RIGHT",Y.LR.ST.NAME,Y.POS)
* PACS00273344 - E
RETURN
* </region>

* <region name="OPEN.FILES" description="Open Files">
OPEN.FILES:
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.COLLATERAL.RIGHT,F.COLLATERAL.RIGHT)
    CALL OPF(FN.REDO.APP.MAPPING,F.REDO.APP.MAPPING)
    CALL OPF(FN.REDO.FC.PROD.COLL.POLICY,F.REDO.FC.PROD.COLL.POLICY)

RETURN
* </region>

* <region name="PROCESS" description="Main Process">
PROCESS:
    GOSUB GET.COLLATERAL.CODES
    IF PROCESS.ERR THEN
        RESULT = 'FAIL'
    END ELSE
        RESULT = 'OK'
    END
RETURN
* </region>

* <region name="GET.COLLATERAL.CODES" description="Get the COLLATERALs CODES to create the corresponding records">
GET.COLLATERAL.CODES:

    Y.RECORD.ID = ''
    Y.CL.CODE   = ''

    CALL CACHE.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.PRODUCT, R.REDO.FC.PROD.COLL.POLICY, Y.ERR)

    Y.NUM.CL.CODES = DCOUNT(R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>, @VM) ;*R22 AUTO CONVERSION START

    FOR I.VAR = 1 TO Y.NUM.CL.CODES
        GOSUB GET.CL.TO.PROCESS
* Itera por cada MV que hayan ingresado
        FOR K.VAR = 1 TO Y.NUM.CL.REC
* Recorre todos los campos
            FOR J.VAR = 1 TO Y.NUM.CL.FIELDS
* init variables
                Y.FIELD.TO   = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>,@VM,J.VAR)
                Y.FIELD.FROM = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM,J.VAR) ;*R22 AUTO CONVERSION END
                Y.FIELD.FROM.T = Y.FIELD.FROM
                Y.CAPTURE.CL.CODE = 0
* fix for PACS00151814
                Y.CUSTOMER.FLD.PREFIX = FIELD( Y.FIELD.FROM,'.',1,3)

                CALL EB.FIND.FIELD.NO(Y.APP.FROM,Y.FIELD.FROM)

                BEGIN CASE
                    CASE Y.FIELD.TO EQ '@ID'
                        Y.CL.FIELD.ID = Y.FIELD.FROM
                        Y.RECORD.ID = FIELD(R.NEW(Y.FIELD.FROM),@VM,K.VAR) ;*R22 AUTO CONVERSION
                        CONTINUE

                    CASE Y.FIELD.TO EQ 'COLLATERAL.CODE'
                        Y.CAPTURE.CL.CODE = 1

* fix for PACS00151814
                    CASE Y.CUSTOMER.FLD.PREFIX EQ 'SEC.HLD.IDEN'
                        Y.CUSTOMER.FLD.POS = Y.FIELD.FROM

                    CASE Y.FIELD.FROM.T EQ 'ADDRESS.BR'
                        Y.ADDRES.BR = FIELD(R.NEW(Y.FIELD.FROM),@VM,K.VAR) ;*R22 AUTO CONVERSION

                END CASE

                GOSUB SET.CL.FIELD
            NEXT J.VAR ;*R22 AUTO CONVERSION

* Send OFS message
            GOSUB PROCESS.COLLATERAL.OFS
            R.COLLATERAL.MSG = ''
            Y.RECORD.ID      = ''
        NEXT K.VAR ;*R22 AUTO CONVERSION
    NEXT I.VAR ;*R22 AUTO CONVERSION

RETURN
* </region>

* <region name="PROCESS.COLLATERAL.OFS" description="Process the OFS messages for COLLATERAL and COLLATERAL.RIGHT">
PROCESS.COLLATERAL.OFS:

    IF Y.RECORD.ID EQ '' THEN
* Crea un nuevo registro
        GOSUB GENERATE.COLLATERAL.ID
    END ELSE
* Ya existe el registro (se ingresaron datos)
* Ya existe no debe crear ni modificar
*JP20110907
        YID.COLL.UNO = FIELD(Y.RECORD.ID,".",1)
        YID.COLL.DOS = FIELD(Y.RECORD.ID,".",2)
        YID.COLL.RIGHT  = YID.COLL.UNO:".":YID.COLL.DOS
        LOCATE YID.COLL.RIGHT IN R.NEW(REDO.FC.ID.COLLATERL.RIGHT)<1,1> SETTING POSCR THEN
*JV20120517 aviod that It try to registered LIMIT.REFENCE more than once time
*            LOCATE R.NEW(REDO.FC.ID.LIMIT) IN R.NEW(REDO.FC.LIMIT.REFERENCE)<1,POSCR> SETTING POSCR1 THEN
*                RETURN
*            END
*JV20120517
            YNRO.LIMIT = DCOUNT(R.NEW(REDO.FC.LIMIT.REFERENCE)<1,POSCR>,@SM) + 1 ;*R22 AUTO CONVERSION
            Y.VAR.CUSTOMER = ''
            Y.VAR.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)

            Y.OFS.MSG.REQ = "COLLATERAL.RIGHT," : Y.VER.COLL.RIGHT : "/I/PROCESS/1/0,/,":YID.COLL.RIGHT:",LIMIT.REFERENCE:":YNRO.LIMIT:":=":Y.VAR.CUSTOMER:".":R.NEW(REDO.FC.ID.LIMIT)

* Process OFS Message
*CALL REDO.UTIL.PROCESS.OFS(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
*R22 MANUAL CONVERSION
            APAP.TAM.redoUtilProcessOfs(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
            GOSUB CHECK.PROCESS
            IF PROCESS.ERR THEN
                RETURN
            END
*READ COLLATERAL RIGHT TO EXTRACT LIMIT R EFERENCE
            YERR=''
            CALL CACHE.READ(FN.COLLATERAL.RIGHT,YID.COLL.RIGHT,R.COLLATERAL.RIGHT,YERR)
            IF YERR THEN
                RETURN
            END
*JV 11042012
            Y.CR.LIMIT = R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE>
            CHANGE @VM TO @SM IN Y.CR.LIMIT ;*R22 AUTO CONVERSION
            GOSUB LIMIT.REF.LOOK.FEEL
            R.NEW(REDO.FC.LIMIT.REFERENCE)<1,POSCR> = Y.CR.LIMIT      ;*JV 11042012 CHANGE VM TO SM
*R.NEW(REDO.FC.LIMIT.REFERENCE)    = R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE>

*JV 11042012
            RETURN
        END


        Y.CL.ID = Y.RECORD.ID
        Y.CR.ID = Y.RECORD.ID[".",1,1] :'.': Y.RECORD.ID[".",2,1]
    END

************************************
* Build COLLATERAL.RIGHT OFS MESSAGE
************************************
    Y.APPLICATION = 'COLLATERAL.RIGHT'
*PACS00151814
    Y.CUSTOMER.ID = FIELD(R.NEW(Y.CUSTOMER.FLD.POS),@VM,K.VAR)   ;* Customer ;*R22 AUTO CONVERSION
    Y.LIMIT       = R.NEW(REDO.FC.ID.LIMIT)       ;* Limit Reference
    Y.VALIDITY.DT = R.NEW(REDO.FC.EFFECT.DATE)    ;* Validity Date

    R.COLL.RIGHT.MSG<COLL.RIGHT.CUSTOMER>        = Y.CUSTOMER.ID
    R.COLL.RIGHT.MSG<COLL.RIGHT.LIMIT.REFERENCE> = Y.LIMIT
    R.COLL.RIGHT.MSG<COLL.RIGHT.COLLATERAL.CODE> = Y.CL.CODE
    R.COLL.RIGHT.MSG<COLL.RIGHT.VALIDITY.DATE>   = Y.VALIDITY.DT
    R.COLL.RIGHT.MSG<COLL.RIGHT.NOTES>           = R.NEW(REDO.FC.NOTES)
* R.COLL.RIGHT.MSG<COLL.RIGHT.EXPIRY.DATE>     = Y.EXPIRY.DT
*PACS00273344 - S
    R.COLL.RIGHT.MSG<COLL.RIGHT.LOCAL.REF,Y.POS> = Y.LR.STATUS
*PACS00273344 - S
    OFS.INFO.INPUT =''
    OFS.INFO.INPUT<1,1> = Y.VER.COLL.RIGHT
    OFS.INFO.INPUT<1,2> = 'I'
    OFS.INFO.INPUT<2,1> = 'PROCESS'
    OFS.INFO.INPUT<2,6> = '0'
    OFS.INFO.INPUT<2,4> = Y.CR.ID
******* reutilizacion de CR por WS *********************


* Setear los MVs del Collateral Right, una vez generados
    Y.CR.IDS    = R.NEW(REDO.FC.ID.COLLATERL.RIGHT)
    Y.CR.LIMIT  = R.NEW(REDO.FC.LIMIT.REFERENCE)
    Y.CR.CODE   = R.NEW(REDO.FC.COLL.RIGHT.CODE)
    Y.CR.VDATE  = R.NEW(REDO.FC.VALIDITY.DATE)
    Y.CR.SEC.ID = R.NEW(REDO.FC.SEC.HOLD.IDENTIF)
    CHANGE @VM TO @SM IN Y.LIMIT          ;*JV 11042012 CHANGE VM TO SM ;*R22 AUTO CONVERSION

    IF Y.CR.IDS EQ '' THEN
        Y.CR.IDS    = Y.CR.ID
        Y.CR.LIMIT  = Y.LIMIT
        Y.CR.CODE   = Y.CL.CODE
        Y.CR.VDATE  = Y.VALIDITY.DT
        Y.CR.SEC.ID = Y.CUSTOMER.ID
    END ELSE
        Y.CR.IDS    := @VM : Y.CR.ID ;*R22 AUTO CONVERSION START
        Y.CR.LIMIT  := @VM : Y.LIMIT
        Y.CR.CODE   := @VM : Y.CL.CODE
        Y.CR.VDATE  := @VM : Y.VALIDITY.DT
        Y.CR.SEC.ID := @VM : Y.CUSTOMER.ID ;*R22 AUTO CONVERSION END
    END

    CALL CACHE.READ(FN.COLLATERAL.RIGHT,YID.COLL.RIGHT,R.COLLATERAL.RIGHT,YERR)
    IF YERR THEN
        CALL OCOMO('ERROR LEYENDO CR')
    END ELSE
        GOSUB CALCULA.C.R


    END

*GOSUB LIMIT.REF.LOOK.FEEL
    R.NEW(REDO.FC.ID.COLLATERL.RIGHT) = Y.CR.IDS
    R.NEW(REDO.FC.LIMIT.REFERENCE)    = Y.CR.LIMIT
    R.NEW(REDO.FC.COLL.RIGHT.CODE)    = Y.CR.CODE
    R.NEW(REDO.FC.VALIDITY.DATE)      = Y.CR.VDATE
    R.NEW(REDO.FC.SEC.HOLD.IDENTIF)   = Y.CR.SEC.ID

*Y.OFS.MSG.REQ = DYN.TO.OFS( R.COLL.RIGHT.MSG , Y.APPLICATION, OFS.INFO.INPUT)
    APP.NAME = Y.APPLICATION ;*R22 MANUAL CONVERSION START-DYN.TO.OFS to OFS.BUILD.RECORD
    OFS.FUNCTION = 'I'
    OFS.PROCESS = 'PROCESS'
    OFS.VERSION = APP.NAME:',':Y.VER.COLL.RIGHT ;*R22 MANUAL CONVERSION- For TC-309/314
    Y.GTSMODE = ''
    NO.OF.AUTH = ''
    TRANSACTION.ID = Y.CR.ID
    R.RECORD = R.COLL.RIGHT.MSG
*   Y.OFS.STR='' ;*R22 MANUAL CONVERSION
    Y.OFS.MSG.REQ = ''
    CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,OFS.PROCESS,OFS.VERSION,Y.GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.RECORD, Y.OFS.MSG.REQ) ;*R22 MANUAL CONVERSION END
* Process OFS Message
*CALL REDO.UTIL.PROCESS.OFS(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
*R22 MANUAL CONVERSION
    APAP.TAM.redoUtilProcessOfs(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
    GOSUB CHECK.PROCESS
    IF PROCESS.ERR THEN
        RETURN
    END
* Capture overrides
*R22 MANUAL CONVERSION START
*R.COLL.RIGHT.RES = OFS.TO.DYN(Y.OFS.MSG.RES,Y.APPLICATION,Y.OFS.INFO)
*    IF R.COLL.RIGHT.RES<COLL.RIGHT.OVERRIDE> NE '' THEN
*        Y.OVERRIDE.MSG = Y.APPLICATION : ' - ' : R.COLL.RIGHT.RES<COLL.RIGHT.OVERRIDE>
*        R.NEW(REDO.FC.OVERRIDE) = R.NEW(REDO.FC.OVERRIDE) : @VM : Y.OVERRIDE.MSG ;*R22 AUTO CONVERSION
*    END
*CALL L.APAP.OFS.TO.DYN(Y.OFS.MSG.RES, Y.OBJECT.TYPE, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.ERROR)
    APAP.LAPAP.lApapOfsToDyn(Y.OFS.MSG.RES, Y.OBJECT.TYPE, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.ERROR)
    LOCATE 'OVERRIDE' IN Y.DYN.RESPONSE.KEY SETTING Y.POS THEN
        Y.OVERRIDE.MSG = Y.APPLICATION : ' - ' : Y.DYN.RESPONSE.VALUE<Y.POS>
        R.NEW(REDO.FC.OVERRIDE) = R.NEW(REDO.FC.OVERRIDE) : @VM : Y.OVERRIDE.MSG
    END
*R22 MANUAL CONVERSION END

******************************
* Build COLLATERAL OFS MESSAGE
******************************
    Y.APPLICATION  = 'COLLATERAL'
    OFS.INFO.INPUT = ''
    OFS.INFO.INPUT<1,1> = Y.VER.COLLATERAL
    OFS.INFO.INPUT<1,2> = 'I'
    OFS.INFO.INPUT<2,1> = 'PROCESS'
    OFS.INFO.INPUT<2,6> = '0'
    OFS.INFO.INPUT<2,4> = Y.CL.ID

* Set product

    CALL System.setVariable("CURRENT.PRODUCT",Y.PRODUCT)
    CALL System.setVariable("CURRENT.CURRENCY",Y.CURRENCY)

* Seteo en R.NEW el valor del ID
    R.NEW(Y.CL.FIELD.ID)<1,K.VAR> = Y.CL.ID ;*R22 AUTO CONVERSION

*Y.OFS.MSG.REQ = DYN.TO.OFS(R.COLLATERAL.MSG, Y.APPLICATION, OFS.INFO.INPUT)
    APP.NAME = 'COLLATERAL.RIGHT' ;*R22 MANUAL CONVERSION START-DYN.TO.OFS to OFS.BUILD.RECORD
    OFS.FUNCTION = 'I'
    OFS.PROCESS = 'PROCESS'
    OFS.VERSION = APP.NAME:',':Y.VER.COLLATERAL ;*R22 MANUAL CONVERSION- For TC-309/314
    Y.GTSMODE = ''
    NO.OF.AUTH = ''
    TRANSACTION.ID = Y.CL.ID
    R.RECORD = R.COLLATERAL.MSG
*   Y.OFS.STR='' ;*R22 MANUAL CONVERSION
    Y.OFS.MSG.REQ = ''
    CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,OFS.PROCESS,OFS.VERSION,Y.GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.RECORD, Y.OFS.MSG.REQ) ;*R22 MANUAL CONVERSION END
* Process OFS Message
*CALL REDO.UTIL.PROCESS.OFS(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
*R22 MANUAL CONVERSION
    APAP.TAM.redoUtilProcessOfs(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
    GOSUB CHECK.PROCESS
    IF PROCESS.ERR THEN
        RETURN
    END

* Capture overrides
*R22 MANUAL CONVERSION START
*R.COLL.RES = OFS.TO.DYN(Y.OFS.MSG.RES,Y.APPLICATION,Y.OFS.INFO)
*    IF R.COLL.RES<COLL.OVERRIDE> NE '' THEN
*        Y.OVERRIDE.MSG = Y.APPLICATION : ' - ' : R.COLL.RES<COLL.OVERRIDE>
*        R.NEW(REDO.FC.OVERRIDE) = R.NEW(REDO.FC.OVERRIDE) : @VM : Y.OVERRIDE.MSG ;*R22 AUTO CONVERSION
*    END
*
*CALL L.APAP.OFS.TO.DYN(Y.OFS.MSG.RES, Y.OBJECT.TYPE, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.ERROR)
    APAP.LAPAP.lApapOfsToDyn(Y.OFS.MSG.RES, Y.OBJECT.TYPE, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.ERROR)
    LOCATE 'OVERRIDE' IN Y.DYN.RESPONSE.KEY SETTING Y.POS THEN
        Y.OVERRIDE.MSG = Y.APPLICATION : ' - ' : Y.DYN.RESPONSE.VALUE<Y.POS>
        R.NEW(REDO.FC.OVERRIDE) = R.NEW(REDO.FC.OVERRIDE) : @VM : Y.OVERRIDE.MSG
    END
*R22 MANUAL CONVERSION END
RETURN
* </region>

* <region name="GET.CL.TO.PROCESS" description="Obtain the Collaterals to process">
GET.CL.TO.PROCESS:
* Obtiene cada COLLATERAL.CODE que el usuario debio haber ingresado
    Y.COLLATERAL.CODE = FIELD(R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>,@VM,I.VAR,1) ;*R22 AUTO CONVERSION

* Obtiene los campos que deberia ingresar de acuerdo al COLLATERAL.CODE obtenido
    REDO.APP.MAPPING.ID = 'CC-' : Y.COLLATERAL.CODE
    CALL CACHE.READ(FN.REDO.APP.MAPPING, REDO.APP.MAPPING.ID, R.REDO.APP.MAPPING, Y.ERR)

* Identifica las posiciones de los campos fijos y locales
    Y.NUM.CL.FIELDS = DCOUNT(R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>, @VM) ;*R22 AUTO CONVERSION START
    Y.APP.TO     = FIELD(R.REDO.APP.MAPPING<REDO.APP.APP.TO>,@VM,1)
    Y.APP.FROM   = FIELD(R.REDO.APP.MAPPING<REDO.APP.APP.FROM>,@VM,1)

* Evalua cuantos registros debe crear de ese COLLATERAL.CODE
    Y.FIELD.TO   = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>,@VM,2)
    Y.FIELD.FROM = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM,2) ;*R22 AUTO CONVERSION END
    Y.NUM.CL.REC = 0

    IF Y.FIELD.TO EQ 'COLLATERAL.CODE' THEN
        CALL EB.FIND.FIELD.NO(Y.APP.FROM,Y.FIELD.FROM)
        Y.NUM.CL.REC = DCOUNT(R.NEW(Y.FIELD.FROM), @VM) ;*R22 AUTO CONVERSION
    END
RETURN
* </region>

* *****************
CALCULA.C.R:
* ******************

    Y.COUNT = 0
    Y.LIMIT.TEMP = Y.LIMIT
    Y.LIMIT = R.NEW(REDO.FC.CUSTOMER):'.000':Y.LIMIT
    Y.CR.LIMIT = R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE>
    Y.COUNT = DCOUNT(R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE>, @VM) ;*R22 AUTO CONVERSION
    IF NOT(Y.COUNT) THEN
        YID.COLL.UNO = FIELD(Y.CR.LIMIT,".",2)
        YID.COLL.DOS = FIELD(Y.CR.LIMIT,".",3)
        Y.CR.LIMIT   = YID.COLL.UNO:".":YID.COLL.DOS

        Y.CR.LIMIT =  SUBSTRINGS(Y.CR.LIMIT, 4,7)
        Y.CR.LIMIT  := @SM : Y.LIMIT ;*R22 AUTO CONVERSION

        Y.CR.LIMIT.CR =  Y.CR.LIMIT
        CHANGE @SM TO @VM IN Y.CR.LIMIT.CR ;*R22 AUTO CONVERSION
        R.COLL.RIGHT.MSG<COLL.RIGHT.LIMIT.REFERENCE> = Y.CR.LIMIT.CR
    END ELSE
        Y.I = 1
        LOOP

        WHILE Y.I LE Y.COUNT
            Y.CR.LIMIT = R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE, Y.I>

            YID.COLL.UNO = FIELD(Y.CR.LIMIT,".",2)
            YID.COLL.DOS = FIELD(Y.CR.LIMIT,".",3)
            Y.CR.LIMIT   = YID.COLL.UNO:".":YID.COLL.DOS

            Y.CR.LIMIT =  SUBSTRINGS(Y.CR.LIMIT, 4,7)
            IF NOT(Y.CR.LIMIT.CR) THEN
                Y.CR.LIMIT.CR =Y.CR.LIMIT
            END ELSE
                Y.CR.LIMIT.CR :=@VM:Y.CR.LIMIT ;*R22 AUTO CONVERSION
            END
            Y.I += 1
        REPEAT
* PARA EL FC
        Y.CR.LIMIT = Y.CR.LIMIT.CR
        Y.CR.LIMIT := @VM:Y.LIMIT.TEMP ;*R22 AUTO CONVERSION
        CHANGE @VM TO @SM IN Y.CR.LIMIT ;*R22 AUTO CONVERSION
* PARA EL C.R
        Y.CR.LIMIT.CR := @VM:Y.LIMIT ;*R22 AUTO CONVERSION
        R.COLL.RIGHT.MSG<COLL.RIGHT.LIMIT.REFERENCE> = Y.CR.LIMIT.CR

    END
    Y.LIMIT = Y.LIMIT.TEMP
RETURN

* <region name="SET.CL.FIELD:" description="Set the COLLATERAL Field">
SET.CL.FIELD:
    CALL EB.FIND.FIELD.NO(Y.APP.TO, Y.FIELD.TO)

    IF NOT(Y.FIELD.TO) THEN
* Es campo local
* Obtener la posicion de LOCAL.REF
        Y.LOCAL.FIELD = 'LOCAL.REF'
        CALL EB.FIND.FIELD.NO(Y.APP.TO, Y.LOCAL.FIELD)

* Obtener la posicion del campo local
        Y.FIELD = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>,@VM,J.VAR) ;*R22 AUTO CONVERSION
        CALL GET.LOC.REF(Y.APP.TO,Y.FIELD,Y.FIELD.NO)
        IF Y.FIELD.FROM.T EQ 'ID.ARRANGEMENT' THEN
            Y.FIELD.FROM.VAL = FIELD(R.NEW(Y.FIELD.FROM),@VM,1) ;*R22 AUTO CONVERSION
        END ELSE
            Y.FIELD.FROM.VAL = FIELD(R.NEW(Y.FIELD.FROM),@VM,K.VAR) ;*R22 AUTO CONVERSION
        END
        R.COLLATERAL.MSG<Y.LOCAL.FIELD,Y.FIELD.NO> = Y.FIELD.FROM.VAL
    END ELSE
* Es campo fijo
*JV05032012 Extract information from a field ADDRESS which one its an exception to send to collateral.
        IF  Y.FIELD.FROM.T EQ 'ADDRESS.BR' AND  Y.ADDRES.BR NE "" THEN
            CHANGE @SM TO @VM IN Y.ADDRES.BR ;*R22 AUTO CONVERSION
            Y.FIELD.FROM.VAL = Y.ADDRES.BR
            R.COLLATERAL.MSG<Y.FIELD.TO> = Y.FIELD.FROM.VAL
        END
        ELSE
            Y.FIELD.FROM.VAL = FIELD(R.NEW(Y.FIELD.FROM),@VM,K.VAR) ;*R22 AUTO CONVERSION
            R.COLLATERAL.MSG<Y.FIELD.TO> = Y.FIELD.FROM.VAL
        END
        IF Y.CAPTURE.CL.CODE THEN
            Y.CL.CODE = Y.FIELD.FROM.VAL
        END
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

* <region name="GENERATE.COLLATERAL.ID" description="Generates CL/CR IDs">
GENERATE.COLLATERAL.ID:
* JP20110714 - Se modifica el proceso de recuperacion del SEQ para Collateral
    IF Y.COLL.SEQ EQ '' THEN
* Obtiene el ultimo COLLATERAL registrado para el customer
        SEL.CMD  = 'SELECT ' :FN.COLLATERAL.RIGHT
        SEL.CMD := '  LIKE ' :R.NEW(REDO.FC.CUSTOMER): '.... BY-DSND @ID'
        SEL.LIST = ''
        NO.REC   = ''
        SEL.ERR  = ''

        CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.REC, SEL.ERR)
        IF NO.REC GT 0 THEN
            LOOP
                REMOVE COLLATERAL.ID.R FROM SEL.LIST SETTING POS
            WHILE COLLATERAL.ID.R
                Y.COLLR <-1> = FMT(FIELD(COLLATERAL.ID.R,'.',2),"2'0'R")
            REPEAT
            Y.COLLR = SORT(Y.COLLR)

* Ya tenia un COLLATERAL previamente registrado
* Genera un nuevo codigo
            Y.NEXT.CR.SEQ = Y.COLLR<NO.REC>
            Y.NEXT.CR.SEQ += 1 ;*R22 AUTO CONVERSION

            Y.CR.ID = R.NEW(REDO.FC.CUSTOMER) : '.' : Y.NEXT.CR.SEQ
        END ELSE
* Crea un nuevo COLLATERAL desde 0
            Y.CR.ID = R.NEW(REDO.FC.CUSTOMER) : '.1'
        END
    END ELSE
* Continua con el siguiente secuencial
        Y.NEXT.CR.SEQ = Y.COLL.SEQ[".",2,1]
        Y.NEXT.CR.SEQ += 1 ;*R22 AUTO CONVERSION

        Y.CR.ID = R.NEW(REDO.FC.CUSTOMER) : '.' : Y.NEXT.CR.SEQ
    END

    GOSUB READ.HISTORY
    Y.CL.ID = Y.CR.ID : '.1'
    Y.COLL.SEQ = Y.CL.ID

RETURN
* </region>

* <region name="READ.HISTORY" description="Reading history records">
READ.HISTORY:
    FN.APP.HIS = 'F.COLLATERAL.RIGHT$HIS'
    F.APP.HIS = ''
    R.APP.HIS = ''

    Y.ERR = ''
    Y.APP.ID = Y.CR.ID : ';1'
    Y.SEQ = Y.CR.ID['.',2,1]

    CALL OPF(FN.APP.HIS,F.APP.HIS)
    CALL F.READ(FN.APP.HIS,Y.APP.ID,R.APP.HIS,F.APP.HIS,Y.ERR)

    IF NOT(Y.ERR) AND R.APP.HIS THEN
        LOOP WHILE R.APP.HIS DO
            Y.SEQ += 1 ;*R22 AUTO CONVERSION
            Y.APP.ID = Y.CR.ID['.',1,1] : '.' : Y.SEQ : ';1'
            CALL F.READ(FN.APP.HIS,Y.APP.ID,R.APP.HIS,F.APP.HIS,Y.ERR)
        REPEAT
    END

* Reemplazar el ID en OFS.MSG.REQ
    Y.CR.ID = Y.APP.ID[';',1,1]

RETURN
* </region>

* <region name="LIMIT.REF.LOOK.FEEL" description="Check Process">
LIMIT.REF.LOOK.FEEL:
*JV11042012 Set the correct format for limit refence
    IF NOT(Y.CR.LIMIT) THEN
        RETURN
    END
    Y.NUM.POS = DCOUNT(Y.CR.LIMIT,@SM) ;*R22 AUTO CONVERSION
    FOR Y.NUM.I = 1 TO Y.NUM.POS

        Y.ID.LIMIT.REF = Y.CR.LIMIT<1,1,Y.NUM.I>[".",2,1]
        Y.ID.LIMIT.SEC = Y.CR.LIMIT<1,1,Y.NUM.I>[".",3,1]
        Y.ID.LIMIT.REF = DROUND(Y.ID.LIMIT.REF)
        Y.CR.LIMIT<1,1,Y.NUM.I> = Y.ID.LIMIT.REF:".":Y.ID.LIMIT.SEC
    NEXT

RETURN
* </region>

END
