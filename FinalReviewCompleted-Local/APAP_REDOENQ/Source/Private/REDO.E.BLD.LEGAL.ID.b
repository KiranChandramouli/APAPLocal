* @ValidationCode : MjotNjA5MzQyNjc0OkNwMTI1MjoxNjgyMDczMzgyMzY0OklUU1M6LTE6LTE6MjY2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 266
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.LEGAL.ID(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name  : REDO.E.BLD.LEGAL.ID
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* which have LEGAL.ID as selection field and file name is equal to customer.
*----------------------------------------------------------
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.USER

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*---------
OPENFILES:
*---------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
    F.CUS.LEGAL.ID = ''
    CALL OPF(FN.CUS.LEGAL.ID,F.CUS.LEGAL.ID)

RETURN

*-------
PROCESS:
*-----------------------------------------
* Main enquiry process is carried on here
*-----------------------------------------
    VAL.CUS.ID = ''

    Y.FILE.NAME = R.ENQ<ENQ.FILE.NAME>
    VAR.APPLICATION = FIELD(Y.FILE.NAME,'$',1)

* This locate part is used to find the customer id of given passport number
    LOCATE 'LEGAL.ID' IN ENQ.DATA<2,1> SETTING LEGAL.POS THEN

        PASSPORT.NUMBER  =  ENQ.DATA<4,LEGAL.POS>

        CALL F.READ(FN.CUS.LEGAL.ID,PASSPORT.NUMBER,R.CUS.LEGAL.ID,F.CUS.LEGAL.ID,CUS.LEGAL.ERR)
        IF R.CUS.LEGAL.ID THEN
            CUS.ID = FIELD(R.CUS.LEGAL.ID,"*",2)
        END ELSE
            CUS.ID = 'ZZZZ'
        END

        GOSUB CHECK.APPLICATION

    END

RETURN
*----------------------------------------
CHECK.APPLICATION:
*----------------------------------------

* This condition is used to check the file enquiry of customer application and make sure the operand of legal id is equal.
* If its nofile enquiry then modify the logic in nofile routine itself.
    IF VAR.APPLICATION EQ 'CUSTOMER' THEN

        LOCATE '@ID' IN ENQ.DATA<2,1> SETTING ID.POS THEN

            VAL.CUS.ID =  ENQ.DATA<4,ID.POS>

        END

        GOSUB CHECK.GIVEN.ID

    END
RETURN
*------------------------------------------
CHECK.GIVEN.ID:
*------------------------------------------
    IF VAL.CUS.ID THEN
        IF (VAL.CUS.ID EQ CUS.ID) THEN
            ENQ.DATA<2,LEGAL.POS> = "@ID"
            ENQ.DATA<4,LEGAL.POS> = CUS.ID
        END ELSE
            ENQ.DATA<2,LEGAL.POS> = "@ID"
            ENQ.DATA<4,LEGAL.POS> = 'ZZZZ'
            ENQ.DATA<4,ID.POS> = 'ZZZZ'

        END
    END

    IF NOT(VAL.CUS.ID) THEN
        ENQ.DATA<2,LEGAL.POS> = "@ID"
        ENQ.DATA<4,LEGAL.POS> = CUS.ID
    END

RETURN
*------------------------------------------
END
