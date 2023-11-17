* @ValidationCode : MjoyMjA3ODY1MzU6Q3AxMjUyOjE2ODMwODE3MDMxNTI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 May 2023 08:11:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE  REDO.PW.PROCESS.OPPOR(R.DATA,L.PROCESS.ID)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This PW routine will map the Process Id

* INPUT/OUTPUT:
*--------------
* IN  : R.DATA
* OUT : L.CUST.ID
*-------------------------------------------------------------------------
*   Date               who           Reference            Description
* 13-SEP-2011     SHANKAR RAJU     ODR-2011-07-0162      Initial Creation
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*12/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*12/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_PW.COMMON
    $INSERT I_F.PW.PROCESS

    GOSUB PROCESS

RETURN

PROCESS:
*-------
    PROCESS.TXN.ID = PW$ACTIVITY.TXN.ID
    CALL PW.FIND.PROCESS(PROCESS.TXN.ID,PW.PROCESS.ID)        ;* get the PW.PROCESS name
    L.PROCESS.ID = PW.PROCESS.ID

RETURN
END
