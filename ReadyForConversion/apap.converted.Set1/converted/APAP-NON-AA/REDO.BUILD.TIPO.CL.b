SUBROUTINE REDO.BUILD.TIPO.CL(ENQ.DATA)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.BUILD.TIPO.CL
* ODR NO      : ODR-2010-09-0142
*----------------------------------------------------------------------
*DESCRIPTION: It is neccessary to create a routine REDO.BUILD.TIPO.CL as
* a Build routine for Enquiry  REDO.CU.VINC.CUSPROF




*IN PARAMETER: ENQ.DATA
*OUT PARAMETER: ENQ.DATA
*LINKED WITH:  REDO.CU.VINC.CUSPROF
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14.09.2010  H GANESH       ODR-2010-09-0142   INITIAL CREATION
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    LOCATE 'L.CU.TIPO.CL' IN ENQ.DATA<2,1> SETTING POS1 THEN
        Y.TIPO.CL=ENQ.DATA<4,POS1>
        CHANGE @SM TO '' IN Y.TIPO.CL
        ENQ.DATA<4,POS1>="'":Y.TIPO.CL:"'"
    END
RETURN

END
