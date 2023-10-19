* @ValidationCode : MjotNjU1NTY2NDIwOkNwMTI1MjoxNjgxODI4MDA0OTYzOklUU1M6LTE6LTE6ODI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 82
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.IST.RESP.MAP.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.IST.RESP.MAP.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a  Validate routine to check entered  IST response and error message id are correct or not
*Linked With  : REDO.ACCT.IST.RESP.MAP
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27 Oct 2010     Swaminathan.S.R      ODR-2009-12-0291          Initial Creation
* 11-04-2023      CONVERSION TOOL      AUTO R22 CODE CONVERSION     VM TO @VM ,FM TO @FM SM TO @SM
* 11-04-2023      jayasurya H          MANUAL R22 CODE CONVERSION   NO CHANGES
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG
    $INSERT I_F.REDO.IST.RESP.CODE
    $INSERT I_F.REDO.CARD.IST.RESP.MAP



    GOSUB PROCESS.PARA

RETURN

**************
PROCESS.PARA:
**************
    IF V$FUNCTION EQ 'I' THEN

        FN.REDO.IST.RESP.CODE = 'F.REDO.IST.RESP.CODE'
        F.REDO.IST.RESP.CODE = ''
        CALL OPF(FN.REDO.IST.RESP.CODE,F.REDO.IST.RESP.CODE)

        GOSUB VALIDATE.PARA
    END
RETURN

***************
VALIDATE.PARA:
***************
    Y.STATUS.COUNT = DCOUNT(R.NEW(REDO.CARD.IST.RESP.MAP.IST.RESPONSE),@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE  Y.STATUS.COUNT
        Y.IST.RESP =  R.NEW(REDO.CARD.IST.RESP.MAP.IST.RESPONSE)<1,Y.CNT>
*********IST RESPONSE CHECK*********

*    CALL F.READ(FN.REDO.IST.RESP.CODE,"SYSTEM",R.REDO.IST.RESP.CODE,F.REDO.IST.RESP.CODE,Y.ERR.IST.RESP) ;*Tus Start
        CALL CACHE.READ(FN.REDO.IST.RESP.CODE,"SYSTEM",R.REDO.IST.RESP.CODE,Y.ERR.IST.RESP) ; * Tus End
        Y.RESP.CODE = R.REDO.IST.RESP.CODE<REDO.IST.RESP.CODE.RESP.CODE>
        LOCATE Y.IST.RESP IN Y.RESP.CODE<1,1> SETTING RESP.POS THEN
        END ELSE
            AF=REDO.CARD.IST.RESP.MAP.IST.RESPONSE
            AV=Y.CNT
            ETEXT = "EB-VALID.RESP.CODE"
            CALL STORE.END.ERROR
        END
        Y.CNT += 1
    REPEAT
RETURN
END
