*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE APAP.H.GARNISH.DETAILS.VALIDATE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :APAP.H.GARNISH.DETAILS.VALIDATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This Template is to store the garnish information

* ----------------------------------------------------------------------------------
* Date           Who       Issue                    Desc
*01 Jun 2011     Prabhu N  PACS00071064             amended to change AMOUNT.LOCKED.VAR
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.GARNISH.DETAILS

    GOSUB PROCESS
    RETURN

PROCESS:
    AMOUNT.LOCKED.VAR=R.NEW(APAP.GAR.AMOUNT.LOCKED)
    UNLOCKED.AMT.VAR=R.NEW(APAP.GAR.GARNISH.AMT.DEL)<1,1>
    R.NEW(APAP.GAR.UNLOCKED.AMT)=R.OLD(APAP.GAR.UNLOCKED.AMT)+R.NEW(APAP.GAR.GARNISH.AMT.DEL)<1,1>

*** Start PACS00592531
*  Y.UNLOCKED.AMT=FMT(R.NEW(APAP.GAR.UNLOCKED.AMT),"R2#20")
    Y.UNLOCKED.AMT = TRIM(R.NEW(APAP.GAR.UNLOCKED.AMT), "", "D")
    R.NEW(APAP.GAR.UNLOCKED.AMT) = Y.UNLOCKED.AMT
*** End PACS00592531

    IF UNLOCKED.AMT.VAR GT AMOUNT.LOCKED.VAR THEN
        AF=APAP.GAR.UNLOCKED.AMT
        ETEXT="EB-AMT.NOT.GREATER"
        CALL STORE.END.ERROR
    END
    RETURN
END
