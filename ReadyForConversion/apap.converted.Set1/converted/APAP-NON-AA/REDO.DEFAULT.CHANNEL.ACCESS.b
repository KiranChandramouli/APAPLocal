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
        Y.VAR1 += 1
    REPEAT

RETURN
END
