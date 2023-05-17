SUBROUTINE   REDO.GET.JULIAN.DATE

*******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.STLMT.BIN.VALIDATE
*********************************************************
*DESCRIPTION: This routine will validate the BIN for settlement process
* When the BIN is not APAP bin or APAP DEBIT Card bin and wrong card number will throw error


*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.VISA.STLMT.FILE.PROCESS
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*01.12.2010  H GANESH        ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------




    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
    $INSERT I_F.DATES


    Y.FIELD.VALUE = R.DATES(EB.DAT.JULIAN.DATE)[3,5]


RETURN
