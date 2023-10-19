* @ValidationCode : MjotNzg5NTYxNzY6Q3AxMjUyOjE2ODI0MTIzNjI1OTM6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.MAXIMUM.VALUE

*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* --------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for :
* Development by  :
* Date            :
*=======================================================================
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.REDO.FC.COLL.CODE.PARAMS

*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN

*
* ======
PROCESS:
* ======
*

    Y.COLLATERAL.TYPE.ID = R.NEW(COLL.COLLATERAL.TYPE)
    CALL F.READ(FN.PARMS,Y.COLLATERAL.TYPE.ID,R.PARMS,F.PARMS,Y.PARMS.ERR.MSG)

    Y.MAX.PERC.LOAN =  R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.PERC>

*   IF Y.MAX.PERC.LOAN GT 0 THEN
*   R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.PERC> =  Y.MAX.PERC.LOAN

    R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE> = Y.NOMINAL.VALUE * Y.MAX.PERC.LOAN / 100

*     R.NEW(COLL.MAXIMUM.VALUE) = R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE>
*   END
*    ELSE
*        AF = Y.COLLATERAL.ID
*        ETEXT = 'ST-REDO.CCRG.MAX.POR.DEF'
*        CALL STORE.END.ERROR
*    END

RETURN


*=========
INITIALISE:
*=========

    FN.PARMS  = 'F.REDO.FC.COLL.CODE.PARAMS'
    F.PARMS   = ''
    R.PARMS   = ''
    Y.PARMS.ERR.MSG = ''

    PROCESS.GOAHEAD = 1
*Set the local fild for read

    WCAMPO    = "L.COL.LN.MX.PER"
    WCAMPO<2> = "L.COL.LN.MX.VAL"

    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOS.MAX.PERC    = YPOS<1,1>
    WPOS.MAX.VALUE   = YPOS<1,2>

*Y.NOMINAL.VALUE = R.NEW(COLL.NOMINAL.VALUE) ; *** VALOR NOMINAL
    Y.NOMINAL.VALUE = COMI      ;*** VALOR NOMINAL
    Y.COLLATERAL.ID = R.NEW(COLL.COLLATERAL.CODE)

    PROCESS.GOAHEAD = 1

RETURN

*
* ========
OPEN.FILES:
*=========
*

    CALL OPF(FN.PARMS,F.PARMS)
RETURN

* ========


END
