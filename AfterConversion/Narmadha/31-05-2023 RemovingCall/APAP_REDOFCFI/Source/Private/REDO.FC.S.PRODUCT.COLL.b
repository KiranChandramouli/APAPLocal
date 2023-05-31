* @ValidationCode : MjotNDM1NzgzNTExOkNwMTI1MjoxNjgwNjA3MTMwNjQ5OklUU1M6LTE6LTE6LTM0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:48:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -34
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.PRODUCT.COLL
*------------------------------------------------------------------------------------------------------------------
* Developer    : MGUDINO@temenos.com
* Date         : 2011-06-13
* Description  : VALIDATE THE RELATION BETWEEN PROD VS COLL
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
*      P.FIELD.NAME              Ofs.Source ID to pass to BULK.MANAGER
*      R.NEW                     Common Variable with current Application Info
* Out :
*      P.MESSAGE                  Message to send by pharent call.
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0              2011-06-14    Marcelo Gudino

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 05-APRIL-2023      Harsha                R22 Auto Conversion  - VM to @VM , FM to @FM and K to K.VAR
* 05-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
*
    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------------------------------------
    Y.ARR.PRODUCT = R.NEW(REDO.FC.PRODUCT)
    Y.COLL.CODES = R.NEW(REDO.FC.TYPE.OF.SEC.BR)
    Y.COLL.CODES := @FM:R.NEW(REDO.FC.TYPE.OF.SEC.VS)
    Y.COLL.CODES := @FM:R.NEW(REDO.FC.TYPE.OF.SEC.TP)
    Y.COLL.CODES := @FM:R.NEW(REDO.FC.TYPE.OF.SEC.DI)
    Y.COLL.CODES := @FM:R.NEW(REDO.FC.TYPE.OF.SEC.DE)
    Y.COLL.CODES := @FM:R.NEW(REDO.FC.TYPE.OF.SEC.FS)

    Y.COLL.RUTINE = 'REDO.FC.S.COLL.BR'
    Y.COLL.RUTINE := @FM:'REDO.FC.S.COLL.VH'
    Y.COLL.RUTINE := @FM:'REDO.FC.S.COLL.TP'
    Y.COLL.RUTINE := @FM:'REDO.FC.S.COLL.DI'
    Y.COLL.RUTINE := @FM:'REDO.FC.S.COLL.DE'
    Y.COLL.RUTINE := @FM:'REDO.FC.S.COLL.FS'
    Y.ROUTINE = ''

    K.POS = 1
    P.MESSAGE = ''
    Y.REDO.FC.POL.ERR= ''

    FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
    F.REDO.FC.PROD.COLL.POLICY = ''
    R.REDO.FC.PROD.COLL.POLICY = ''

RETURN

*------------------------------------------------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------------------------------------------------

*   Paragraph that open files
*

RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS:
*
*------------------------------------------------------------------------------------------------------------------
*
    CALL CACHE.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.ARR.PRODUCT, R.REDO.FC.PROD.COLL.POLICY, Y.REDO.FC.POL.ERR)
    IF Y.REDO.FC.POL.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : Y.ARR.PRODUCT
        CALL STORE.END.ERROR
        RETURN
    END

* PRODUCT VS COLLATERAL
    FOR Y.I = 1 TO 6
        Y.COLLATERAL.CODE = Y.COLL.CODES<Y.I>
        IF Y.COLLATERAL.CODE THEN
            Y.ROUTINE = Y.COLL.RUTINE<Y.I>
            GOSUB PROCESS.COLL
            CALL @Y.ROUTINE
        END
    NEXT

RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS.COLL:
*------------------------------------------------------------------------------------------------------------------

    NRO.COLLS = DCOUNT(Y.COLLATERAL.CODE,@VM) + 1

    FOR JJ = 1 TO NRO.COLLS
        P.MESSAGE = ''
        IF Y.COLLATERAL.CODE<1,JJ> THEN
            LOCATE Y.COLLATERAL.CODE<1,JJ> IN R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE,1> SETTING K.VAR ELSE
                TEXT = 'TIPO DE GARANTIA NO PARAMETRIZADA PARA EL PRODUCTO ':Y.COLLATERAL.CODE
            END
            IF TEXT THEN
* JP20110824 se adiciona las siguientes lineas
                NO.OVER = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) +  1
                CALL STORE.OVERRIDE(NO.OVER)
            END
        END
    NEXT

RETURN

END
