* @ValidationCode : MjotMjA2ODM4NjY3OTpDcDEyNTI6MTY4NDgzNjAzMzE2NjpJVFNTOi0xOi0xOjE5MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 193
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.AUTH.REPRINT.SLIP
*----------------------------------------------------------------------------------------------------------------------
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Temenos Development
*  Program   Name    :REDO.APAP.AUTH.REPRINT.SLIP
*----------------------------------------------------------------------------------------------------------------------
*Description:    This is an AUTHORISATION routine attached to the Enquiry used
*                to REPRINT a deal slip when the User clicks on REPRINT option
*----------------------------------------------------------------------------------------------------------------------
*linked with:
*In parameter:
*Out parameter:
*----------------------------------------------------------------------------------------------------------------------
* Modification History :
* Date                  who                   Reference              
* 04-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 04-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------------------------------------------------
* DATE         WHO                REFERENCE           DESCRIPTION
* 27-01-2011   C.SRIRAMAN         ODR-2011-01-0103    INITIAL CREATION
* 03-05-2011   Sudharsanan S      PACS00055008        Update REDO.PRINT.REPRINT.IDS with id as FT/TT/T24FS and value as
*                                                     ContractId*HoldId
* 16-09-2013   Vignesh Kumaar R   PACS00316982        DEALSLIP REPRINT REVAMP
* 26-07-2017   Saran              PACS00612004        Fix for Reprint Dealslip enquiry
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.H.REPRINT.SEQ

    R.NEW(REDO.REP.SEQ.REPRINT.SEQ)  = R.NEW(REDO.REP.SEQ.REPRINT.SEQ) + 1
    Y.NEW.ID = FIELD(ID.NEW,'-',1)

    IF PGM.VERSION EQ ",PRINT.SLIP" THEN
        R.NEW(REDO.REP.SEQ.INIT.PRINT)="YES"
    END

    FN.REDO.CASHIER.DEALSLIP.INFO = 'F.REDO.CASHIER.DEALSLIP.INFO'
    F.REDO.CASHIER.DEALSLIP.INFO = ''
    CALL OPF(FN.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO)

    IF PGM.VERSION EQ ',REPRINT.SLIP' THEN
        R.REDO.CASHIER.DEALSLIP.INFO = 'REPRINT'
*    WRITE R.REDO.CASHIER.DEALSLIP.INFO TO F.REDO.CASHIER.DEALSLIP.INFO, Y.NEW.ID ;*Tus Start
        CALL F.WRITE(FN.REDO.CASHIER.DEALSLIP.INFO,Y.NEW.ID,R.REDO.CASHIER.DEALSLIP.INFO)
* Tus end
*    END ELSE
*        TEXT = 'REDO.REPRINT.APPROVAL'
*        CURR.NO = 1
*        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN
