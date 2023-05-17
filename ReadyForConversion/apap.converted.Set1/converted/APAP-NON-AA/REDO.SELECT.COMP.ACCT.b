SUBROUTINE REDO.SELECT.COMP.ACCT(ENQ.DATA)
*----------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: TAM
* PROGRAM NAME: REDO.SELECT.COMP.ACCT
*----------------------------------------------------------------------
*DESCRIPTION  : This is a build routine used for selection of branch code
*LINKED WITH  : Enquiry REDO.LIST.NOSTRO.ACCTS
*IN PARAMETER : ENQ.DATA
*OUT PARAMETER: ENQ.DATA
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO                REFERENCE         DESCRIPTION
*26 MAY 2010  Mohammed Anies K   ODR-2010-03-0447  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*----------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------
PROCESS:
* Defaulting ID.COMPANY to selection field BRANCH.CODE

    ENQ.DATA<2,1>='BRANCH.CODE'
    ENQ.DATA<3,1>='EQ'
    ENQ.DATA<4,1>=ID.COMPANY

RETURN
*---------------------------------------------------------------------
END
