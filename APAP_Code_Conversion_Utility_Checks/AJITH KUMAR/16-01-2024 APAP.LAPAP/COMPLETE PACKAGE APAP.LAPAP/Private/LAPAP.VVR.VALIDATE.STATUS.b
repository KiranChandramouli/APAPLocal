* @ValidationCode : MjoxMzkxMzY0NDU4OkNwMTI1MjoxNjg0MjIyODE5NDg0OklUU1M6LTE6LTE6NDg0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 484
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.VVR.VALIDATE.STATUS
*--------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*24-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,INSERT FILE MODIFIED
*24-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CUST.PRD.LIST       ;*R22 AUTO CODE CONVERSION
    $INSERT I_System


    GOSUB INIT
    GOSUB UPD.STATUS
RETURN

INIT:
    FN.CUST.PRD.LIST = 'F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST = ''
    CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF(FN.ACC,F.ACC)
RETURN

UPD.STATUS:

    IF PGM.VERSION EQ ',REDO.STATUS.ALL.PF' OR PGM.VERSION EQ ',REDO.STATUS.ALL.MEN' THEN

        Y.STATUS = R.OLD(EB.CUS.CUSTOMER.STATUS)

        IF Y.STATUS EQ 3 THEN

            ETEXT = "PARA ELIMINAR ESTATUS DE FALLECIDO CONTACTE A OPERACIONES"
            CALL STORE.END.ERROR

        END

    END

    IF R.NEW(EB.CUS.CURR.NO) EQ '' THEN
        R.NEW(EB.CUS.CUSTOMER.STATUS) = '1'
    END
    IF COMI EQ '4' THEN
*        CALL F.READ(FN.CUST.PRD.LIST,ID.NEW,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR)
        CALL F.READU(FN.CUST.PRD.LIST,ID.NEW,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR,'');* R22 UTILITY AUTO CONVERSION
        Y.PRD.STATUS.LIST = R.CUST.PRD.LIST<PRD.PRD.STATUS>
        Y.PRD.PRODUCT.LIST = R.CUST.PRD.LIST<PRD.PRODUCT.ID>
        CHANGE @VM TO @FM IN Y.PRD.STATUS.LIST
        CHANGE @VM TO @FM IN Y.PRD.PRODUCT.LIST
        Y.PRD.QNTT = DCOUNT(Y.PRD.PRODUCT.LIST, @FM)
        FOR A = 1 TO Y.PRD.QNTT STEP 1
            Y.CURR.PRD = Y.PRD.PRODUCT.LIST<A>
            CALL F.READ(FN.ACC,Y.CURR.PRD,R.ACC,F.ACC,ACC.ERR)
            IF R.ACC THEN
                Y.ACC.CUSTOMER = R.ACC<AC.CUSTOMER>
                Y.ACC.JOIN.HOL = R.ACC<AC.JOINT.HOLDER>
                IF Y.ACC.CUSTOMER EQ ID.NEW THEN
                    TEXT = "PRODUCTO NUM.:" : Y.CURR.PRD : ", ESTA ACTIVO."
                    E = TEXT
                    CALL STORE.END.ERROR
                    RETURN
                END
                FINDSTR ID.NEW IN Y.ACC.JOIN.HOL SETTING V.FLD, V.VAL THEN
                    TEXT = "PRODUCTO COMPARTIDO NUM.:" : Y.CURR.PRD : ", ESTA ACTIVO."
                    E = TEXT
                    CALL STORE.END.ERROR
                    RETURN
                END
            END
        NEXT A
*SI LLEGO A ESTE PUNTO, ES PORQUE NO HAY PRODUCTO ACTIVO EN REALIDAD...
*ELIMINO EL REGISTRO DE REDO.CUST.PRD.LIST PARA QUE NO HAYA TEMAS A FUTURO...
        CALL F.DELETE(FN.CUST.PRD.LIST,ID.NEW)
*LOCATE 'ACTIVE' IN Y.PRD.STATUS.LIST SETTING POS THEN
*    ETEXT = "EB-REDO.ACTIVE.PRD.FOUND"
*    CALL STORE.END.ERROR
*END
    END
RETURN
END
