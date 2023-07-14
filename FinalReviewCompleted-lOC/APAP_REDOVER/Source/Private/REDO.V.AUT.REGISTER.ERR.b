* @ValidationCode : Mjo1NjA2NTI0MzM6Q3AxMjUyOjE2ODI0MTIzMzU4MTg6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:35
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
SUBROUTINE REDO.V.AUT.REGISTER.ERR
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.AUT.REGISTER.UPD
*--------------------------------------------------------------------------------------------------------
*Description  : This is an authorisation routine to update STOCK.REGISTER
*Linked With  : STOCK.ENTRY,REDO.CARDMV
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 4 Aug 2010    Mohammed Anies K       ODR-2010-03-0400         Initial Creation
*--------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                          DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion              VM TO @VM,SM TO @SM
*10-04-2023              Samaran T                R22 Manual Code conversion               No Changes
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.REDO.CARD.REQUEST


    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.STOCK.ENTRY = 'F.STOCK.ENTRY'
    F.STOCK.ENTRY = ''
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)

    FN.STOCK.REGISTER = 'F.STOCK.REGISTER'
    F.STOCK.REGISTER = ''
    CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)

    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

    R.STOCK.REGISTER = ''
    REG.ID = ''
    Y.NO.DAMAGE.CARD = ''
    Y.NO.LOST.CARD = ''
    Y.DAMAGE.LOST.NO = ''

RETURN

*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------
* used to update the STOCK.REGISTER for no.of card demaged
* number of demaged card details can be ontained from the local reference field created in STOCK.ENTRY application

    GOSUB GET.LOCAL.REF.FIELDS

    Y.REDO.CARD.REQUEST.ID=R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.BATCH.NO.POS>
    CALL F.READ(FN.REDO.CARD.REQUEST,Y.REDO.CARD.REQUEST.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,F.ERR)

    REG.ID = R.NEW(STO.ENT.TO.REGISTER)
    CALL F.READ(FN.STOCK.REGISTER,REG.ID,R.STOCK.REGISTER,F.STOCK.REGISTER,ERR)

    Y.TOT.CARD.SERIES = DCOUNT(R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.CRD.SERIES.POS>,@SM)

    IF Y.TOT.CARD.SERIES NE '0' THEN

        Y.INIT.CARD.SERIES = 1
        LOOP
        WHILE Y.INIT.CARD.SERIES LE Y.TOT.CARD.SERIES
            Y.STOCK.SERIES = R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.CRD.SERIES.POS,Y.INIT.CARD.SERIES>
            Y.NO.DAMAGE.CARD = R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.DAMAGE.NO.POS,Y.INIT.CARD.SERIES>
            Y.NO.LOST.CARD = R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.CARDS.LOST.POS,Y.INIT.CARD.SERIES>

            IF Y.NO.DAMAGE.CARD EQ '' AND Y.NO.LOST.CARD EQ '' THEN
                R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.CRD.SERIES.POS,Y.INIT.CARD.SERIES> = ''
                RETURN
            END

            GOSUB CHECK.STOCK.VAL

            Y.INIT.CARD.SERIES +=1
        REPEAT
    END

RETURN
*-----------------------------------------------------------------------------------
CHECK.STOCK.VAL:
*-----------------

    Y.CARD.STOCK.ENTRY = R.NEW(STO.ENT.STOCK.SERIES)
    LOCATE Y.STOCK.SERIES IN Y.CARD.STOCK.ENTRY<1,1> SETTING Y.CARD.SERIES.ID.POS THEN
        Y.STK.QTY = R.NEW(STO.ENT.STOCK.QUANTITY)<1,Y.CARD.SERIES.ID.POS>
        IF Y.NO.DAMAGE.CARD GT Y.STK.QTY THEN
            AF = STO.ENT.LOCAL.REF
            AV = L.SE.DAMAGE.NO.POS
            AS = Y.INIT.CARD.SERIES
            ETEXT = "EB-DAMAGE.LOST.NO"
            CALL STORE.END.ERROR
        END
        IF Y.NO.LOST.CARD GT Y.STK.QTY THEN
            AF = STO.ENT.LOCAL.REF
            AV = L.SE.CARDS.LOST.POS
            AS = Y.INIT.CARD.SERIES
            ETEXT = "EB-DAMAGE.LOST.NO"
            CALL STORE.END.ERROR
        END
    END ELSE
        AF = STO.ENT.LOCAL.REF
        AV = L.SE.CRD.SERIES.POS
        AS = Y.INIT.CARD.SERIES
        ETEXT = "EB-INVALID.SERIES"
        CALL STORE.END.ERROR
    END

RETURN
*-----------------------------------------------------------------------------------
********************
GET.LOCAL.REF.FIELDS:
********************
*In this para of code local reference field positions are identified

    APPL.ARRAY='STOCK.ENTRY'
    FLD.ARRAY='L.SE.DAMAGED.NO':@VM:'L.SE.CARDS.LOST':@VM:'L.SE.CRD.SERIES':@VM:'L.SE.BATCH.NO'
    FLD.POS=''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.SE.DAMAGE.NO.POS   = FLD.POS<1,1>
    L.SE.CARDS.LOST.POS  = FLD.POS<1,2>
    L.SE.CRD.SERIES.POS  = FLD.POS<1,3>
    L.SE.BATCH.NO.POS    = FLD.POS<1,4>

RETURN
*--------------------------------------------------------------------------------------------------------
END
