* @ValidationCode : MjotMjg5Mzc1NTI3OkNwMTI1MjoxNjg0ODQyMTUwNTQwOklUU1M6LTE6LTE6OTI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 92
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, SM TO @SM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
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
