* @ValidationCode : MjotMTE5OTE1MTYzOTpDcDEyNTI6MTY4NDQ5MTAzMzczMjpJVFNTOi0xOi0xOjI1MjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 252
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION       FM TO @FM, VM TO @VM, SM TO @SM,
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.FC.S.PROD.CL.TYPE.TP(ENQ.DATA)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 15.06.2011
* Description  : NOFILE Enquiry Routine para Clase de Garantia en Template FC
* Attached to  : Enquiry REDO.FC.PROD.COLL.TYPE.TP
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
    $INSERT I_F.COLLATERAL.CODE

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
* </region>

    GOSUB INIT
    GOSUB OPEN.FILES
    IF LEN(Y.PARAM) LE 3 THEN
        GOSUB INV.EXT.PROCESS
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

    FN.COLLATERAL.CODE = 'F.COLLATERAL.CODE'
    F.COLLATERAL.CODE = ''

    Y.ERR = ''

    Y.CL.CODE = ''
    Y.CL.TYPE.DATA = ''
    Y.CL.TYPE.BUFFER = ''

    LOCATE '@ID' IN D.FIELDS SETTING Y.POS THEN
        Y.PARAM = D.RANGE.AND.VALUE<Y.POS>
    END

RETURN

*************
OPEN.FILES:
* Open Files
*************
    CALL OPF(FN.REDO.FC.PROD.COLL.POLICY,F.REDO.FC.PROD.COLL.POLICY)
    CALL OPF(FN.COLLATERAL.TYPE,F.COLLATERAL.TYPE)
    CALL OPF(FN.COLLATERAL.CODE,F.COLLATERAL.CODE)

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
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.COLLATERAL.TYPE
        CALL STORE.END.ERROR
    END

    Y.CL.TYPE.DATA<2> = R.COLLATERAL.TYPE<COLL.TYPE.DESCRIPTION>

RETURN

********************************
INV.EXT.PROCESS:
* Process records for the
* product CONS.CG.GTIA.INV.EXT2
********************************
    CALL CACHE.READ(FN.COLLATERAL.CODE,Y.PARAM,R.COLLATERAL.CODE,Y.ERR)
    IF Y.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.COLLATERAL.TYPE
        CALL STORE.END.ERROR
    END

    Y.COLL.TYPES = R.COLLATERAL.CODE<COLL.CODE.COLLATERAL.TYPE>
    Y.NUM.CL.TYPES = DCOUNT(Y.COLL.TYPES,@VM)
    FOR Y.NUM.CL.TYPE = 1 TO Y.NUM.CL.TYPES
        Y.CL.TYPE = FIELD(Y.COLL.TYPES,@VM,Y.NUM.CL.TYPE)
* Clase de Garantia
        Y.CL.TYPE.DATA<1> = Y.CL.TYPE
* Descripcion
        GOSUB GET.CL.TYPE.DESCRIPTION
        CHANGE @FM TO "*" IN Y.CL.TYPE.DATA
        ENQ.DATA<-1> = Y.CL.TYPE.DATA
    NEXT Y.NUM.CL.TYPE

RETURN
* </region>

END
