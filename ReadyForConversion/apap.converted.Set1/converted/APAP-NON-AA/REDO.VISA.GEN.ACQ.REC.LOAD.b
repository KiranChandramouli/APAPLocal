SUBROUTINE  REDO.VISA.GEN.ACQ.REC.LOAD
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.GEN.ACQ.REC.LOAD
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --STLMT.LINES--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*07/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_REDO.VISA.GEN.ACQ.REC.COMMON
    $INSERT I_F.REDO.VISA.OUT.MAP

    GOSUB OPEN.FILES
    GOSUB READING

RETURN


*------------------------------------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------------------------------------

    FN.ATM.REVERSAL='F.ATM.REVERSAL'
    F.ATM.REVERSAL=''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER=''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.REDO.VISA.OUTGOING='F.REDO.VISA.OUTGOING'
    F.REDO.VISA.OUTGOING=''
    CALL OPF(FN.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING)

    FN.REDO.VISA.OUT.MAP='F.REDO.VISA.OUT.MAP'
    F.REDO.VISA.OUT.MAP = ''
    CALL OPF(FN.REDO.VISA.OUT.MAP,F.REDO.VISA.OUT.MAP)

    FN.REDO.VISA.FT.LOG='F.REDO.VISA.FT.LOG'
    F.REDO.VISA.FT.LOG=''
    CALL OPF(FN.REDO.VISA.FT.LOG,F.REDO.VISA.FT.LOG)

    FN.REDO.VISA.GEN.OUT = 'F.REDO.VISA.GEN.OUT'
    F.REDO.VISA.GEN.OUT = ''
    CALL OPF(FN.REDO.VISA.GEN.OUT,F.REDO.VISA.GEN.OUT)

RETURN

*------------------------------------------------------------------------------------
READING:
*------------------------------------------------------------------------------------
*READING FN.REDO.VISA.OUT.MAP USING ID AS SYSTEM

    REDO.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.VISA.OUT.MAP,REDO.ID,R.REDO.VISA.OUT.MAP,REDO.ERR)

RETURN
END
