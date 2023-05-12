* @ValidationCode : Mjo1MjcwMzA1MDQ6Q3AxMjUyOjE2ODA3NzU2NjIzODU6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:37:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.DEFAULT.CHANNEL.ACCESS
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.DEFAULT.CHANNEL.ACCESS
*Date              : 09.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
*Description:
*----------------
* This routine is used to default the channel access in LATAM.CARD.ORDER
* Will be called from ID routine of LATAM.CARD.ORDER.ID before retrieving the new ID
*-------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*09/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*01 Oct 2011     Balagurunathan              ODR-2010-08-0469       Recompilation of routine
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            VM TO @VM, ++ TO +=
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION          NOCHANGE
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CHANNEL.DEF
    $INSERT I_F.LATAM.CARD.ORDER

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------
    CHNL.DEF='' ; NO.ACCESS=''
    Y.ID='SYSTEM'
RETURN
*------------------------------------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------------------------------------
    FN.REDO.CHANNEL.DEF='F.REDO.CHANNEL.DEF'

RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
*READING REDO.CHANNEL.DEF

    CALL CACHE.READ(FN.REDO.CHANNEL.DEF,Y.ID,R.REDO.CHANNEL.DEF,DEF.ERR)
    CHNL.DEF=R.REDO.CHANNEL.DEF<CHNL.DEF.CHNL.DEF>
    NO.ACCESS=R.REDO.CHANNEL.DEF<CHNL.DEF.DEF.NO.ACCESS>

    Y.CHN.DEF.CNT=DCOUNT(CHNL.DEF,@VM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.CHN.DEF.CNT
        IF NO.ACCESS<1,Y.VAR1> EQ 'NO' THEN
            R.NEW(CARD.IS.CHANNEL.DENY)<1,-1>= CHNL.DEF<1,Y.VAR1>
        END
        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN
END
