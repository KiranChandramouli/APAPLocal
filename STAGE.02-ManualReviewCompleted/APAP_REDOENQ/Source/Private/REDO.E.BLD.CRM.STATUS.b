$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.CRM.STATUS(ENQ.DATA)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : PRADEEP S
* Program Name  : REDO.E.BLD.CRM.STATUS
*-------------------------------------------------------------------------

* Description : This is a Build routine which will be executed to display the
* Closed Status linked to particular application

* In parameter : ENQ.DATA
* out parameter : ENQ.DATA
* Linked with : Build routine for the enquiry REDO.CRM.CLOSED.STATUS
*-------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE"
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_System

    GOSUB PROCESS

RETURN
*********
PROCESS:
*********

    Y.PGM.VERSION = System.getVariable('CURRENT.PGM.VER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN           ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.PGM.VERSION = ""
    END
    Y.APPLICATION = System.getVariable('CURRENT.APPLICATION')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN          ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE"
        Y.APPLICATION = ""
    END

    ENQ.DATA<2,1> = '@ID'
    ENQ.DATA<3,1> = 'EQ'
    ENQ.DATA<4,1>= Y.APPLICATION:Y.PGM.VERSION

RETURN

************************************************************************
END
