* @ValidationCode : MjoxMDE3MTY2MzIwOkNwMTI1MjoxNjg0ODQyMTUwNDg3OklUU1M6LTE6LTE6NTg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 585
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
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
