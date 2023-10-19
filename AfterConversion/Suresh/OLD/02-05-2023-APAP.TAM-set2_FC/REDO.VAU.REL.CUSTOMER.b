* @ValidationCode : MjotMTQ2NDk5MzEwOkNwMTI1MjoxNjgxODkxOTAwNTU5OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:41:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAU.REL.CUSTOMER
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
*To be added in VERSION.CONTROL On authorization of CUSTOMER application  to update the CONCAT table REDO.REL.CUSTOMER

*------------------------------------------------------------------------------------------------------
*APPLICATION
* VERSION.CONTROL of CUSTOMER
*-------------------------------------------------------------------------------------------------------

*
* Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.VAU.REL.CUSTOMER
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*23.08.2010      Janani     ODR-2010-03-0150  INITIAL CREATION
* ----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.REL.CUSTOMER

    GOSUB INIT
    GOSUB PROCESS
    GOSUB DELETE
RETURN

*------------------------------------------------------------
INIT:
*------------------------------------------------------------
    FN.REDO.REL.CUSTOMER = 'F.REDO.REL.CUSTOMER'
    F.REDO.REL.CUSTOMER = ''
    R.REDO.REL.CUSTOMER = ''
    CALL OPF(FN.REDO.REL.CUSTOMER,F.REDO.REL.CUSTOMER)

RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

    RELATION.CODE = R.NEW(EB.CUS.RELATION.CODE)
    LOCATE "106" IN RELATION.CODE<1,1> SETTING POS THEN
        IF R.OLD(EB.CUS.RELATION.CODE)<1,POS> NE R.NEW(EB.CUS.RELATION.CODE)<1,POS> OR R.OLD(EB.CUS.REL.CUSTOMER)<1,POS> NE R.NEW(EB.CUS.REL.CUSTOMER)<1,POS> THEN
            REL.CUSTOMER = R.NEW(EB.CUS.REL.CUSTOMER)<1,POS>
            CALL F.READ(FN.REDO.REL.CUSTOMER,REL.CUSTOMER,R.REDO.REL.CUSTOMER,F.REDO.REL.CUSTOMER,READ.ERR)
            LOCATE ID.NEW IN R.REDO.REL.CUSTOMER SETTING CUS.POS ELSE
                R.REDO.REL.CUSTOMER<-1> = ID.NEW
                CALL F.WRITE(FN.REDO.REL.CUSTOMER,REL.CUSTOMER,R.REDO.REL.CUSTOMER)
            END
        END
    END
RETURN
*------------------------------------------------------------
DELETE:
*------------------------------------------------------------
    OLD.REL.CODE = R.OLD(EB.CUS.RELATION.CODE)
    NEW.REL.CODE  =R.NEW(EB.CUS.RELATION.CODE)
    LOCATE "106" IN OLD.REL.CODE<1,1> SETTING DEL.POS THEN
        IF R.OLD(EB.CUS.RELATION.CODE)<1,DEL.POS> NE R.NEW(EB.CUS.RELATION.CODE)<1,DEL.POS> OR R.OLD(EB.CUS.REL.CUSTOMER)<1,DEL.POS> NE R.NEW(EB.CUS.REL.CUSTOMER)<1,DEL.POS> THEN
            REL.CUSTOMER = R.OLD(EB.CUS.REL.CUSTOMER)<1,DEL.POS>
            CALL F.READ(FN.REDO.REL.CUSTOMER,REL.CUSTOMER,R.REDO.REL.CUSTOMER,F.REDO.REL.CUSTOMER,READ.ERR)
            LOCATE ID.NEW IN R.REDO.REL.CUSTOMER SETTING CUS.POS THEN
                DEL R.REDO.REL.CUSTOMER<CUS.POS>
                GOSUB GODELETE
            END
        END
    END
RETURN
*------------------------------------------------------------
GODELETE:
*------------------------------------------------------------
    IF R.REDO.REL.CUSTOMER THEN
        CALL F.WRITE(FN.REDO.REL.CUSTOMER,REL.CUSTOMER,R.REDO.REL.CUSTOMER)
    END ELSE
        CALL F.DELETE(FN.REDO.REL.CUSTOMER,REL.CUSTOMER)
    END
RETURN
*------------------------------------------------------------
END
