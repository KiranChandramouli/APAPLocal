SUBROUTINE REDO.FC.S.GET.COLL.TYPE.CG(INFO,ENQ.DATA)
*-----------------------------------------------------------------------------
* Developer    : Jorge Valarezo (jvalarezoulloa@temenos.com)
* Date         : 03.12.2012
* Description  : NOFILE Enquiry Routine para Clase de Garantia en Template FC
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
*
*-----------------------------------------------------------------------------
* Input/Output:
*               INFO <1>: Product
*               INFO <2>: Collateral Code
* Output:
*         ENQ.DATA (Enquiry Data Result)
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON

    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COLLATERAL.TYPE

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
* </region>


    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="GOSUBS">
*************
INIT:
* Initialize
*************
    FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
    F.REDO.FC.PROD.COLL.POLICY = ''
    R.REDO.FC.PROD.COLL.POLICY = ''

    FN.COLLATERAL.TYPE = 'F.COLLATERAL.TYPE'
    F.COLLATERAL.TYPE = ''
    R.COLLATERAL.TYPE = ''

    Y.ERR = ''
    Y.FC.PRODUCTO = INFO<1>
    Y.COLL.COD    = INFO<2>
    Y.COLL.COD.POS= 0
    Y.CL.CODE = ''
    Y.CL.TYPE.DATA = ''
    Y.CL.TYPE.BUFFER = ''

RETURN

*************
OPEN.FILES:
* Open Files
*************
    CALL OPF(FN.REDO.FC.PROD.COLL.POLICY,F.REDO.FC.PROD.COLL.POLICY)
    CALL OPF(FN.COLLATERAL.TYPE,F.COLLATERAL.TYPE)

RETURN

***************
PROCESS:
* Main Process
***************

    CALL CACHE.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.FC.PRODUCTO, R.REDO.FC.PROD.COLL.POLICY, Y.ERR)
    IF Y.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.REDO.FC.PROD.COLL.POLICY
        CALL STORE.END.ERROR
    END
    Y.COLL.CODES = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>

    LOCATE Y.COLL.COD IN Y.COLL.CODES<1,1> SETTING Y.COLL.COD.POS ELSE
        RETURN
    END


    Y.COLL.TYPES = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.TYPE,Y.COLL.COD.POS>
    Y.NUM.CL.TYPES = DCOUNT(Y.COLL.TYPES,@SM)
    Y.NUM.CL.TYPE = 1
    LOOP
    WHILE Y.NUM.CL.TYPE LE Y.NUM.CL.TYPES
        Y.CL.TYPE = FIELD(Y.COLL.TYPES,@SM,Y.NUM.CL.TYPE)
* Supress duplicates
        LOCATE Y.CL.TYPE IN Y.CL.TYPE.BUFFER<1,1> SETTING Y.POS ELSE
            IF Y.CL.TYPE.BUFFER EQ '' THEN
                Y.CL.TYPE.BUFFER = Y.CL.TYPE
            END ELSE
                Y.CL.TYPE.BUFFER := @VM : Y.CL.TYPE
            END
* Clase de Garantia
            Y.CL.TYPE.DATA<1> = Y.CL.TYPE
* Descripcion
            GOSUB GET.CL.TYPE.DESCRIPTION
            CHANGE @FM TO "*" IN Y.CL.TYPE.DATA
            ENQ.DATA<-1> = Y.CL.TYPE.DATA
        END
        Y.NUM.CL.TYPE += 1
    REPEAT

RETURN

**********************************
GET.CL.TYPE.DESCRIPTION:
* Get Collateral Type Description
**********************************
    CALL CACHE.READ(FN.COLLATERAL.TYPE,Y.CL.TYPE,R.COLLATERAL.TYPE,Y.ERR)
    IF Y.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.REDO.FC.PROD.COLL.POLICY
        CALL STORE.END.ERROR
    END

    Y.CL.TYPE.DATA<2> = R.COLLATERAL.TYPE<COLL.TYPE.DESCRIPTION>

RETURN


* </region>

END
