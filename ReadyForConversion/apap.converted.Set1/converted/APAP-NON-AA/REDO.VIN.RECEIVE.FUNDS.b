SUBROUTINE REDO.VIN.RECEIVE.FUNDS
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description:
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
*
*
*
*--------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.TELLER
*
*--------------------------------------------------------------------------------------------
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
    IF Y.TEXT.MSG THEN
        ETEXT  = Y.TEXT.MSG
        AF     = TT.TE.AMOUNT.LOCAL.1
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
*
*
RETURN
*
*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------
*
    LOOP.CNT         = 1
    MAX.LOOPS        = 1
    PROCESS.GOAHEAD  = 1
    Y.TEXT.MSG       = ""
*
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.NEXT.VERSION"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    CALL MULTI.GET.LOC.REF("TELLER",WCAMPO,YPOS)
    WPOS.LI  = YPOS<1,1>
    WPOS.NV  = YPOS<1,2>
*
    WINITIAL.ID   = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI>
    WNEXT.VERSION = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.NV>
*
RETURN
*
*--------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------
*
*
RETURN
*
*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1

                IF WINITIAL.ID EQ "" THEN
                    Y.TEXT.MSG      = "EB-TRANSACTION.NOT.ALLOWED"
                    PROCESS.GOAHEAD = ""
                END

        END CASE

        LOOP.CNT +=1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------

END
