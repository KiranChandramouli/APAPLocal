* @ValidationCode : Mjo4NjMxOTc4MjI6Q3AxMjUyOjE2ODI0MTIzNjQzNDI6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:04
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
SUBROUTINE REDO.V.VAL.SEC
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.SEC
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,L.CONT + 1 to +=1
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.SECTOR
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    L.CONT = 0
* Get the sector to find
    VAR.SECTOR = R.NEW(COLL.LOCAL.REF)<1,WPOS.SECTOR>

* find the rector in the application REDO.SECTOR.DOMI
    SELECT.STATEMENT = 'SELECT ':FN.AZ:' WITH @ID LIKE ':VAR.SECTOR
    LOCK.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,LOCK.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

*GET ALL VALUES FROM THE LIST AND ADD THE LOCK VALUE
    LOOP
        REMOVE Y.ID.AA.PRD FROM LOCK.LIST SETTING POS
    WHILE Y.ID.AA.PRD:POS

        CALL CACHE.READ(FN.AZ, Y.ID.AA.PRD, R.AZ, Y.ERR)

        L.CONT += 1

*IF Y.ERR NE '' THEN
*     P.MESSAGE = "ST-REDO.COLLA.ERR.LEE.LOCK"
*     RETURN
*  END
    REPEAT

    IF L.CONT EQ 0 THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        ETEXT = 'ST-SECTOR.ERROR'
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------------


INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    L.CONT = 0

    FN.AZ   = 'F.REDO.SECTOR.DOMI'
    F.AZ    = ''
    R.AZ    = ''

*Read the local fields
    WCAMPO = "L.COL.SECTOR"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
    WPOS.SECTOR  = YPOS<1,1>

RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.AZ,F.AZ)
RETURN
*------------
END
