* @ValidationCode : MjotMTIzNjQzODg1NzpDcDEyNTI6MTY4MjU3ODI5NTA1Mzp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 12:21:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.REST.LIST.VP(ENQ.DATA)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.04.2013
* Description  : Routine for obtaining Credit Card Information
* Type         : NOFILE Routine
* Attached to  : ENQUIRY > AI.REDO.CCARD.DETAILS.CHANGE
* Dependencies :
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
*
* 18-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM
* 18-APR-2023      Harishvikram C   Manual R22 conversion    CALL routine format modified
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_F.CUSTOMER
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $USING APAP.TAM
    $USING APAP.REDOSRTN

* </region>
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
    FN.REDO.RESTRICTIVE.LIST = 'F.REDO.RESTRICTIVE.LIST'
    F.REDO.RESTRICTIVE.LIST = ''

    FN.REDO.VALUATOR.NAME = 'F.REDO.VALUATOR.NAME'
    F.REDO.VALUATOR.NAME = ''
    R.REDO.VALUATOR.NAME = ''

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    R.CUSTOMER = ''

    Y.ERR = ''

    RL.LIST = ''
    RL.LIST.NAME = ''
    RL.SELECTED = ''
    RL.RETURN.CODE = ''

    CU.LIST = ''
    CU.LIST.NAME = ''
    CU.SELECTED = ''
    CU.RETURN.CODE = ''

    Y.NUMERO.DOC = ''
    Y.CUST.NAME = ''

    Y.DATA = ''

    LOCATE 'NUMERO.DOC' IN D.FIELDS SETTING Y.POS THEN
        Y.NUMERO.DOC = D.RANGE.AND.VALUE<Y.POS>
    END

    LOCATE 'CUSTOMER.NAME' IN D.FIELDS SETTING Y.POS THEN
        Y.CUST.NAME = D.RANGE.AND.VALUE<Y.POS>
    END

RETURN

***********************
* Open Files
OPEN.FILES:
***********************
    CALL OPF(FN.REDO.RESTRICTIVE.LIST, F.REDO.RESTRICTIVE.LIST)
    CALL OPF(FN.REDO.VALUATOR.NAME, F.REDO.VALUATOR.NAME)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

***********************
* Main Process
PROCESS:
***********************
* Restrictive List
    Y.NUMERO.DOC.STRIPPED = OCONV(Y.NUMERO.DOC,"MCB")

    SELECT.STATEMENT  = "SELECT " : FN.REDO.RESTRICTIVE.LIST
    IF Y.NUMERO.DOC EQ Y.NUMERO.DOC.STRIPPED THEN
        SELECT.STATEMENT := " WITH NUMERO.DOCUMENTO EQ '" : Y.NUMERO.DOC : "'"
    END ELSE
        SELECT.STATEMENT := " WITH NUMERO.DOCUMENTO EQ '" : Y.NUMERO.DOC : "' OR NUMERO.DOCUMENTO EQ '" : Y.NUMERO.DOC.STRIPPED : "'"
    END

    CALL EB.READLIST(SELECT.STATEMENT, RL.LIST, RL.LIST.NAME, RL.SELECTED, RL.RETURN.CODE)

    IF RL.SELECTED GT 0 THEN
        Y.DATA<1> = 'YES'
    END ELSE
        Y.DATA<1> = 'NO'
    END

* PEPS
    SELECT.STATEMENT = "SELECT " : FN.CUSTOMER
    SELECT.STATEMENT := " WITH L.CU.CIDENT EQ '" : Y.NUMERO.DOC : "'"

    CALL EB.READLIST(SELECT.STATEMENT, CU.LIST, CU.LIST.NAME, CU.SELECTED, CU.RETURN.CODE)
    IF CU.SELECTED GT 0 THEN
        REMOVE CUST.ID FROM CU.LIST SETTING CU.POS
        CALL F.READ(FN.CUSTOMER,CUST.ID, R.CUSTOMER, F.CUSTOMER, Y.ERR)

        OFAC.GIVEN.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
        OFAC.FAMILY.NAME = R.CUSTOMER<EB.CUS.FAMILY.NAME>
        OFAC.CUS.NAME1   = R.CUSTOMER<EB.CUS.NAME.1>
        OFAC.CUS.NAME2   = R.CUSTOMER<EB.CUS.NAME.2>
        OFAC.CUS.TEXT    = R.CUSTOMER<EB.CUS.TEXT>

        CU.APPLICATION = 'CUSTOMER'
        CU.LOCAL.REF = 'LOCAL.REF'
        CALL EB.FIND.FIELD.NO(CU.APPLICATION, CU.LOCAL.REF)

        CU.LOCAL.FIELDS = ''
        CU.LOCAL.FIELDS.POS = ''

        CU.LOCAL.FIELDS<1,1> = 'L.CU.PEPS'
        CU.LOCAL.FIELDS<1,2> = 'L.CU.TIPO.CL'

        CALL MULTI.GET.LOC.REF(CU.APPLICATION, CU.LOCAL.FIELDS, CU.LOCAL.FIELDS.POS)

        CU.PEPS.POS   = CU.LOCAL.FIELDS.POS<1,1>
        OFAC.TIPO.CL  = R.CUSTOMER<CU.LOCAL.REF,CU.LOCAL.FIELDS.POS<1,2>>

        IF NOT(R.CUSTOMER<CU.LOCAL.REF,CU.PEPS.POS>) THEN
            Y.DATA<3> = 'NO'
        END ELSE
            IF R.CUSTOMER<CU.LOCAL.REF,CU.PEPS.POS> EQ 'SI' THEN
                Y.DATA<3> = 'YES'
            END ELSE
                Y.DATA<3> = 'NO'
            END
        END
    END ELSE
        Y.DATA<3> = 'NO'
    END

* OFAC
    CALL APAP.TAM.redoFindCustOfac(OFAC.TIPO.CL,Y.CUST.NAME,OFAC.GIVEN.NAMES,OFAC.FAMILY.NAME,OFAC.CUS.NAME1,OFAC.CUS.NAME2,OFAC.CUS.TEXT,OFAC.RET) ;*Manual R22 conversion
    Y.DATA<2> = OFAC.RET
    IF OFAC.RET EQ '' THEN
* Log writing: OFAC did not return valid value YES/NO
        CALL APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL007', 'ONLINE', '04', 'OFAC', 'ERROR EN LISTAS RESTRICTIVAS A LAS ' : TIMEDATE(), '', '', '', '', '', '', '') ;*Manual R22 conversion
    END

* Tasador
    CALL F.READ(FN.REDO.VALUATOR.NAME, Y.NUMERO.DOC, R.REDO.VALUATOR.NAME, F.REDO.VALUATOR.NAME, Y.ERR)
    IF R.REDO.VALUATOR.NAME THEN
        Y.DATA<4> = 'YES'
    END ELSE
        Y.DATA<4> = 'NO'
    END

    CHANGE @FM TO "*" IN Y.DATA
    ENQ.DATA<-1> = Y.DATA

RETURN

* </region>

END
