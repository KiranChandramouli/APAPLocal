* @ValidationCode : MjoyMTQ1Mzg2NzkwOkNwMTI1MjoxNjgwNzc3MzI2OTI4Om11dGh1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:05:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : muthu
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.REPRINT.CHQ
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Temenos Development
*  Program   Name    :REDO.AUTH.REPRINT.CHQ
***********************************************************************************
*Description:    This is an AUTHORISATION routine attached to the Enquiry used
*                to PRINT a deal slip when the User clicks on PRINT option
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
**********************************************************************
* DATE         WHO                REFERENCE       DESCRIPTION
* 11-01-2012   Sudharsanan        PACS00169921    Initial Creation
* 13/06/2013   Vignesh Kumaar R   PACS00265097    REPRINT DEALSLIP FOR INAO TT RECORDS
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
****************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_F.REDO.PRINT.CHQ.LIST

    $INSERT I_RC.COMMON
    $INSERT I_F.REDO.REPRINT.INAO.TT

    GOSUB PROCESS

RETURN
*---------
PROCESS:
*----------

    FN.REDO.REPRINT.INAO.TT = 'F.REDO.REPRINT.INAO.TT'
    F.REDO.REPRINT.INAO.TT = ''
    CALL OPF(FN.REDO.REPRINT.INAO.TT,F.REDO.REPRINT.INAO.TT)

    VAR.PRINT =  R.NEW(PRINT.CHQ.LIST.PRINT)
    VAR.OVERR =  R.NEW(PRINT.CHQ.LIST.OVERRIDE)

    IF VAR.OVERR EQ "" THEN     ;* PACS00249046 - S
        R.NEW(PRINT.CHQ.LIST.OVERRIDE) = ''
    END     ;* PACS00249046 - E
*

    IF VAR.PRINT EQ 'Y' THEN
*        OFS$DEAL.SLIP.PRINTING = 1
*        CALL PRODUCE.DEAL.SLIP('CHQ.PRINT.ADMIN')

        Y.PRINTER.TYPE = R.NEW(PRINT.CHQ.LIST.SET.PRINTER)
        Y.CHQ.TYPE = R.NEW(PRINT.CHQ.LIST.CHQ.TYPE)

        BEGIN CASE
            CASE Y.PRINTER.TYPE EQ 'EPSON'
                IF Y.CHQ.TYPE EQ 'MANAGER' THEN
                    Y.SLIP.ID = 'CHQ.PRINT.MGEPS'
                END ELSE
                    Y.SLIP.ID = 'CHQ.PRINT.EPS'
                END

            CASE Y.PRINTER.TYPE EQ 'OLIVETTI'
                IF Y.CHQ.TYPE EQ 'MANAGER' THEN
                    Y.SLIP.ID = 'CHQ.PRINT.MGOLI'
                END ELSE
                    Y.SLIP.ID = 'CHQ.PRINT.OLI'
                END

            CASE OTHERWISE
                IF Y.CHQ.TYPE EQ 'MANAGER' THEN
                    Y.SLIP.ID = 'CHQ.PRINT.MGRIC'
                END ELSE
                    Y.SLIP.ID = 'CHQ.PRINT.RIC'
                END

        END CASE

* Fix for PACS00265097 [REPRINT DEALSLIP FOR INAO TT RECORDS]

        OFS$DEAL.SLIP.PRINTING = 0
        CALL PRODUCE.DEAL.SLIP(Y.SLIP.ID)

        R.REDO.REPRINT.INAO.TT = ''
        R.REDO.REPRINT.INAO.TT<REDO.TT.INAO.CHQ.PRINTED> = 'NO'
        R.REDO.REPRINT.INAO.TT<REDO.TT.INAO.HOLD.CTRL.ID> = C$LAST.HOLD.ID
        GET.USER.ID = R.NEW(PRINT.CHQ.LIST.INPUTTER)
        GET.OPERATOR = FIELD(GET.USER.ID,'_',2)
        R.REDO.REPRINT.INAO.TT<REDO.TT.INAO.TILL.USER> = GET.OPERATOR
        CALL F.WRITE(FN.REDO.REPRINT.INAO.TT,ID.NEW,R.REDO.REPRINT.INAO.TT)

* End of Fix

    END
RETURN
*------------------------------------------------------------------------------------
END
