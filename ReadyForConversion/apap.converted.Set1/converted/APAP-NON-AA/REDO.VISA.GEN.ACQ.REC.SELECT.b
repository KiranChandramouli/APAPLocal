SUBROUTINE  REDO.VISA.GEN.ACQ.REC.SELECT
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.GEN.ACQ.REC.SELECT
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
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
    $INSERT I_BATCH.FILES

    GOSUB PROCESS

RETURN


*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
*Read the file REDO.VISA.FT.LOG with id

    FTTC.ID=BATCH.DETAILS<3,1>
    CHANGE @SM TO @FM IN FTTC.ID
    LOOP
        REMOVE Y.FTTC.ID FROM FTTC.ID SETTING ID.POS
    WHILE Y.FTTC.ID:ID.POS
        R.REDO.VISA.FT.LOG = ''
        CALL F.READ(FN.REDO.VISA.FT.LOG,Y.FTTC.ID,R.REDO.VISA.FT.LOG,F.REDO.VISA.FT.LOG,FTTC.ERR)
        OUT.ARRAY<-1>=R.REDO.VISA.FT.LOG
    REPEAT
    CALL BATCH.BUILD.LIST('',OUT.ARRAY)
RETURN
END
