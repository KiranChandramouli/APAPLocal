$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.DEALER.BOOK(DEALER.BOOK.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.NOF.DEALER.BOOK
*--------------------------------------------------------------------------------------------------------
*Description  : This is a no file enquiry routine for displaying the DEALER BOOK ids from SC.TRADING.POSITION
*Linked With  : REDO.DEALER.BOOK
*In Parameter : N/A
*Out Parameter: LN.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
* 23th Aug 2010    SWAMINATHAN.S.R       ODR-2010-08-0422       Initial Creation
* 12-APRIL-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.SC.TRADING.POSITION
    $INSERT I_F.MM.MONEY.MARKET


    FN.STP = 'F.SC.TRADING.POSITION'
    F.STP = ''
    CALL OPF(FN.STP,F.STP)
    STP.DEALER.BOOK = ''

    FN.MM = 'F.MM.MONEY.MARKET'
    F.MM = ''
    CALL OPF(FN.MM,F.MM)
    MM.DEALER.BOOK = ''

    APPL.ARRAY = "MM.MONEY.MARKET"
    FLD.ARRAY = "L.MM.OWN.PORT"
    FLD.POS = ""
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.MM.OWN.PORT = FLD.POS<1,1>


    SEL.CMD.STP = "SELECT ":FN.STP:" WITH DEALER.BOOK NE '' "

    CALL EB.READLIST(SEL.CMD.STP,STP.ID.LIST,'',NOF.REC.STP,Y.ERR.STP)

    LOOP
        REMOVE Y.STP.ID FROM STP.ID.LIST SETTING STP.POS
    WHILE Y.STP.ID:STP.POS
        CALL F.READ(FN.STP,Y.STP.ID,R.STP,F.STP,Y.ERR.STP)
        Y.DEALER.BOOK = R.STP<SC.TRP.DEALER.BOOK>
        LOCATE Y.DEALER.BOOK IN STP.DEALER.BOOK<-1> SETTING Y.TYPE.INVST.POS THEN
        END ELSE
            INS Y.DEALER.BOOK BEFORE STP.DEALER.BOOK<-1>
        END
    REPEAT

    SEL.CMD.MM = "SELECT ":FN.MM:" WITH L.MM.OWN.PORT NE '' "
    CALL EB.READLIST(SEL.CMD.MM,MM.ID.LIST,'',NOF.REC.MM,Y.ERR.MM)
    LOOP
        REMOVE Y.MM.ID FROM MM.ID.LIST SETTING MM.POS
    WHILE Y.MM.ID:MM.POS
        CALL F.READ(FN.MM,Y.MM.ID,R.MM,F.MM,Y.ERR.MM)
        Y.OWN.BOOK = R.MM<MM.LOCAL.REF,LOC.L.MM.OWN.PORT>
        LOCATE Y.OWN.BOOK IN MM.DEALER.BOOK<-1> SETTING Y.TYPE.INVST.POS THEN
        END ELSE
            INS Y.OWN.BOOK BEFORE MM.DEALER.BOOK<-1>
        END
    REPEAT

    DEALER.BOOK.ARRAY<-1> = MM.DEALER.BOOK:@FM:STP.DEALER.BOOK
RETURN
END
