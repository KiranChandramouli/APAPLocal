SUBROUTINE REDO.S.FETCH.DOB(DOB.DATE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.FETCH.DOB
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the date and Convert the date into
*                   dd mon yy (e.g. 01 JAN 09)
*LINKED WITH       :
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS
RETURN

PROCESS:
*PACS00142988 - S
    TEMP.COMI = COMI ; TEMP.N1=N1 ; TEMP.T1 = T1
    COMI= DOB.DATE; N1=8 ; T1=".D"
    CALL IN2D(N1,T1)
    DOB.DATE = V$DISPLAY
    COMI = TEMP.COMI ; N1 = TEMP.N1 ; T1 = TEMP.T1
*PACS00142988 - E
RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
