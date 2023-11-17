$PACKAGE APAP.TAM
SUBROUTINE V.REDO.INT.PARAM.BA.RTN
*-----------------------------------------------------------------------------
*  Name: REDO.INTERFACE.PARAM.BEFORE.AUTHORIZATION.ROUTINE
*  C.1 Collector Interface
*-----------------------------------------------------------------------------
* This routines allows to encrypt sensitive information, whom is recorded into REDO.INTERFACE.PARAM
* This will attached to VERSION.CONTROL
* The encrypted info will be recorded into REDO.COL.DB.CONNECTION liveFile on Encrypted Format
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package redo.coll
*
*
* Note: It uses an "hardcode" key to encrypt the info. The key is kept on I_REDO.COL.COMMON

** 19-04-2023 R22 Auto Conversion no changes
** 19-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT JBC.h
    $INSERT I_REDO.COL.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM

*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    IF NOT(Y.CONTINUE) THEN     ;* This is used just on Collector Interface
        RETURN
    END
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* For every sensitive field to encrypt
    LOOP
        REMOVE Y.PARAM.TYPE.ID FROM Y.PARAM.TYPE.LIST SETTING Y.PARAM.TYPE.MARK
    WHILE Y.PARAM.TYPE.ID : Y.PARAM.TYPE.MARK
* Check, if the field data was changed
        paramType = Y.PARAM.TYPE.ID
        fieldParamValue = R.OLD(REDO.INT.PARAM.PARAM.VALUE)
        GOSUB GET.PARAM.TYPE.VALUE
        paramOldValue = paramValue
        fieldParamValue = R.NEW(REDO.INT.PARAM.PARAM.VALUE)
        GOSUB GET.PARAM.TYPE.VALUE
        paramNewValue = paramValue
        IF valueNo EQ 0 THEN
            E = "PARAMETER & NOT INPUT"
            E<2> = paramType
            RETURN
        END
* if the used maked changed, then accept them as new connection info
        IF paramOldValue NE paramNewValue THEN
* Show ***
            R.NEW(REDO.INT.PARAM.PARAM.VALUE)<1,valueNo> = STR("*",LEN(paramNewValue))
            paramNewValue = ENCRYPT(paramNewValue,K_ENCRYPT_KEY,JBASE_CRYPT_3DES_BASE64)
            BEGIN CASE
                CASE Y.PARAM.TYPE.ID EQ "DB.USER"
                    R.REDO.COL.DB.CONNECTION<1> = paramNewValue
                CASE Y.PARAM.TYPE.ID EQ "DB.PASSWORD"
                    R.REDO.COL.DB.CONNECTION<2> = paramNewValue
                CASE 1
                    E = "PARAMETER & NOT DEFINED AS SENSITIVE INFO"
                    E<2> = Y.PARAM.TYPE.ID
            END CASE
        END

    REPEAT

    CALL F.WRITE(FN.REDO.COL.DB.CONNECTION, ID.NEW,R.REDO.COL.DB.CONNECTION)

RETURN
*** <region name= Initialise>
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    Y.CONTINUE = 1
* It's a record related with COLLECTOR interface ?
    IF ID.NEW[1,3] NE "COL" THEN
        Y.CONTINUE = 0
        RETURN
    END
    fieldParamType = R.NEW(REDO.INT.PARAM.PARAM.TYPE)

    FN.REDO.COL.DB.CONNECTION = 'F.REDO.COL.DB.CONNECTION'
    F.REDO.COL.DB.CONNECTION = ''
    CALL OPF(FN.REDO.COL.DB.CONNECTION,F.REDO.COL.DB.CONNECTION)
    R.REDO.COL.DB.CONNECTION = ''
    CALL CACHE.READ(FN.REDO.COL.DB.CONNECTION, ID.NEW, R.REDO.COL.DB.CONNECTION, YERR)

RETURN

*** <region name= getParamTypeValue>
*** paramType  (in)  to search
*** paramValue (out) value found
*** valueNo    (out) position of the value
*-----------------------------------------------------------------------------
GET.PARAM.TYPE.VALUE:
*-----------------------------------------------------------------------------

    valueNo = 0
    paramValue = ""
    LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
        paramValue = fieldParamValue<1, valueNo>
    END ELSE
        valueNo = 0
    END
RETURN
*-----------------------------------------------------------------------------
END
