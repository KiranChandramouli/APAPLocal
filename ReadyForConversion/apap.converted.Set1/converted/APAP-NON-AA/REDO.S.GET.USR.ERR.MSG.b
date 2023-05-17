FUNCTION REDO.S.GET.USR.ERR.MSG(P.ERR.CODE)
*-----------------------------------------------------------------------------
* Subroutine Type : General Routine
* Attached to     :
* Attached as     :
* Primary Purpose : Get "User Message" according to error code passed. Used on
*                   Batch/Tsa service
*
* Incoming:
* ---------
*            P.ERR.CODE
*                       <1>        Error Code (EB.ERROR>@ID)
*                       <2>        Values for variable sections
*
* Outgoing:
* ---------
*            P.USR.MSG               User Message
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 10/05/13 - hpasquel@temenos.com
*            First Version
* 14/04/14 - msthandier@temenos.com
*            Adaptation for APAP
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB INITIALIZE
    IF PROCESS.GO.AHEAD THEN
        GOSUB PROCESS
    END

RETURN P.USR.MSG
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
*
    PROCESS.GO.AHEAD = P.ERR.CODE NE ""
*
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*
    ERR.MESS = P.ERR.CODE       ;* GLOBUS_EN_10000012/S
    CALL EB.GET.ERROR.MESSAGE(ERR.MESS)
    yErrExist = (ERR.MESS<8> NE "")
    ERR.MESS = ERR.MESS<1>:@FM:ERR.MESS<2> ;* GLOBUS_EN_10000012/E
*
    P.USR.MSG = ERR.MESS
*
    CALL TXT(P.USR.MSG)
*
    IF yErrExist THEN
        P.USR.MSG = P.USR.MSG     ;* : " - " : P.ERR.CODE<1>
    END
*
RETURN
*-----------------------------------------------------------------------------
END
