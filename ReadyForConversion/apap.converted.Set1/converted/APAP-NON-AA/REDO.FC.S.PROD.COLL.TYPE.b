SUBROUTINE REDO.FC.S.PROD.COLL.TYPE(ENQ.DATA)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 15.06.2011
* Description  : NOFILE Enquiry Routine para Clase de Garantia en Template FC
* Attached to  : Enquiry REDO.FC.PROD.COLL.TYPE
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       15.06.2011      lpazmino          CR.180         Initial Version
*-----------------------------------------------------------------------------
* Input/Output: NA/ENQ.DATA (Enquiry Data Result)
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

* Special case for the product CONS.CG.GTIA.INV.EXT2
* Due it allows 2 collaterals at the same time
    IF Y.PRODUCT EQ 'CONS.CG.GTIA.INV.EXT2' THEN
* Identify which collateral is being called
* Y.CL.TYPE.FIELD = OFS$HOT.FIELD
        Y.CL.CODE.TP = R.NEW(REDO.FC.TYPE.OF.SEC.TP)
        Y.CL.CODE.DE = R.NEW(REDO.FC.TYPE.OF.SEC.DE)

        IF Y.CL.CODE.TP EQ '' AND Y.CL.CODE.DE EQ '' THEN
            GOSUB PROCESS
        END ELSE
            IF Y.CL.CODE.TP EQ 100 AND Y.CL.CODE.DE EQ 200 THEN
                GOSUB PROCESS
                RETURN
            END
            IF Y.CL.CODE.TP EQ 100 AND Y.CL.CODE.DE EQ '' THEN
                Y.CL.CODE = 100
            END
            IF Y.CL.CODE.DE EQ 200 AND Y.CL.CODE.DE EQ '' THEN
                Y.CL.CODE = 200
            END
            GOSUB INV.EXT.PROCESS
            RETURN
        END
    END ELSE
        GOSUB PROCESS
    END

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

    Y.CL.CODE = ''
    Y.CL.TYPE.DATA = ''
    Y.CL.TYPE.BUFFER = ''

    LOCATE '@ID' IN D.FIELDS SETTING Y.POS THEN
        Y.PRODUCT = D.RANGE.AND.VALUE<Y.POS>
    END

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
    CALL CACHE.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.PRODUCT, R.REDO.FC.PROD.COLL.POLICY, Y.ERR)
    IF Y.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.REDO.FC.PROD.COLL.POLICY
        CALL STORE.END.ERROR
    END
    Y.COLL.TYPES = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.TYPE>
    Y.NUM.CL.TYPES = DCOUNT(Y.COLL.TYPES,@SM)
    FOR Y.NUM.CL.TYPE = 1 TO Y.NUM.CL.TYPES
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
    NEXT Y.NUM.CL.TYPE

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

********************************
INV.EXT.PROCESS:
* Process records for the
* product CONS.CG.GTIA.INV.EXT2
********************************
    CALL CACHE.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.PRODUCT, R.REDO.FC.PROD.COLL.POLICY, Y.ERR)
    IF Y.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.REDO.FC.PROD.COLL.POLICY
        CALL STORE.END.ERROR
    END

    Y.COLL.CODES = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>
    LOCATE Y.CL.CODE IN Y.COLL.CODES<1,1> SETTING Y.POS THEN
        Y.COLL.TYPES = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.TYPE,Y.POS>
        Y.NUM.CL.TYPES = DCOUNT(Y.COLL.TYPES,@SM)
        FOR Y.NUM.CL.TYPE = 1 TO Y.NUM.CL.TYPES
            Y.CL.TYPE = FIELD(Y.COLL.TYPES,@SM,Y.NUM.CL.TYPE)
* Clase de Garantia
            Y.CL.TYPE.DATA<1> = Y.CL.TYPE
* Descripcion
            GOSUB GET.CL.TYPE.DESCRIPTION
            CHANGE @FM TO "*" IN Y.CL.TYPE.DATA
            ENQ.DATA<-1> = Y.CL.TYPE.DATA
        NEXT Y.NUM.CL.TYPE
    END

RETURN
* </region>

END
