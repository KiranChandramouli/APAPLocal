$PACKAGE APAP.TAM
SUBROUTINE REDO.VISA.GEN.CHGBCK.OUT.LOAD
***************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VISA.GEN.CHGBCK.OUT.LOAD
***********************************************************************************
*Description: This routine is to pick the set of outgoing CHARGEBACK records which
*             are already to send as outgoing file
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*07.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
** 19-04-2023 R22 Auto Conversion no changes
** 19-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON



    GOSUB INIT

RETURN

******
INIT:
******

    FN.REDO.VISA.CHGBCK.LOG ='F.REDO.VISA.CHGBCK.LOG'
    F.REDO.VISA.CHGBCK.LOG =''
    CALL OPF(FN.REDO.VISA.CHGBCK.LOG,F.REDO.VISA.CHGBCK.LOG)

*FN.REDO.VISA.GEN.CHGBCK.OUT ='F.REDO.VISA.GEN.CHGBCK.OUT'
*F.REDO.VISE.GEN.CHGBCK.OUT  =''
*CALL OPF(FN.REDO.VISA.GEN.CHGBCK.OUT,F.REDO.VISE.GEN.CHGBCK.OUT)

    FN.REDO.VISA.OUTGOING = 'F.REDO.VISA.OUTGOING'
    F.REDO.VISA.OUTGOING = ''
    CALL OPF(FN.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING)

    FN.VISA.OUT.CHGBCK.LINES='F.VISA.OUT.CHGBCK.LINES'
    F.VISA.OUT.CHGBCK.LINES=''
    CALL OPF(FN.VISA.OUT.CHGBCK.LINES,F.VISA.OUT.CHGBCK.LINES)

    FN.REDO.VISA.STLMT.MAPPING ='F.REDO.VISA.STLMT.MAPPING'
    F.REDO.VISA.STLMT.MAPPING=''
    CALL OPF(FN.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING)

    FN.REDO.VISA.STLMT.PARAM = 'F.REDO.VISA.STLMT.PARAM'

    PARAM.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.VISA.STLMT.PARAM,PARAM.ID,R.REDO.VISA.STLMT.PARAM,REDO.VISA.STLMT.PARAM.ERR)

RETURN

END
