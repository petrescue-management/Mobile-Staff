import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prs_staff/src/style.dart';
import 'package:prs_staff/view/personal/policy/policy.dart';

final String mapKey = 'AIzaSyAZ4pja68qoa62hCzFdlmAu30iAb_CgmTk';

final adoptionPolicy = RichText(
  text: TextSpan(
    style: TextStyle(
      fontFamily: 'Philosopher',
      color: darkBlue,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 1.3,
    ),
    children: [
      TextSpan(
        style: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        text:
            'Trước khi quyết định nhận nuôi bé chó hay mèo nào, bạn hãy tự hỏi bản thân rằng mình đã sẵn sàng để chịu trách nhiệm cả đời cho bé chưa, cả về tài chính, nơi ở cũng như tinh thần.\n',
      ),
      TextSpan(
        style: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        text:
            'Việc nhận nuôi cần được sự đồng thuận lớn từ bản thân bạn cũng như gia đình và những người liên quan. Xin cân nhắc kỹ trước khi đăng ký nhận nuôi các bé.\n\n',
      ),
      TextSpan(
        text: 'BẠN ĐÃ SẴN SÀNG? Hãy lưu ý những diều sau:\n\n',
      ),
      TextSpan(
        text:
            '- Đa số các bé được cứu về trong tình trạng tồi tệ, tinh thần không tốt, nên việc đi xa sẽ khó cho các bé. Những bạn ở xa nơi trung tâm quản lý bé hãy hết sức lưu ý diều này.\n',
      ),
      TextSpan(
        text:
            '- Sau khi đăng ký nhận nuôi, trung tâm cứu hộ sẽ liên hệ phỏng vấn bạn vài điều. Phần phỏng vấn có thể có nhiều câu hỏi mang tính chất riêng tư, vì vậy mong bạn hãy kiên nhẫn nhé!\n',
      ),
      TextSpan(
        text:
            '- Trung tâm cứu hộ sẽ thu một khoản tiền vía (bao gồm các khoản chi về y tế trước đây cho bé, cũng như để hỗ trợ chi phí chăm sóc, nuôi dưỡng các bé khác tại nhà chung).\n',
      ),
      TextSpan(
        text:
            '- Tiền vía mỗi bé sẽ khác nhau tùy thuộc vào tình trạng của bé khi cứu cũng như các dịch vụ y tế (tiêm phòng, triệt sản) đã thực hiện.\n',
      ),
      TextSpan(
        text:
            '- Sau khi mang các bé về nuôi, bạn cần cập nhật trạng thái của các bé trong 3 tháng để phía trung tâm theo dõi tình trạng sức khỏe cũng như đảm bảo các bé về đúng nhà.\n',
      ),
      TextSpan(
        text:
            '- Trường hợp bạn không nuôi được tiếp cần trả lại cho trung tâm cứu hộ, không tự ý đem cho người khác.\n',
      ),
    ],
  ),
);

final volunteerPolicy = RichText(
  text: TextSpan(
    style: TextStyle(
      fontFamily: 'Philosopher',
      color: darkBlue,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 1.3,
    ),
    children: [
      TextSpan(
        style: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        text:
            ' Hiện tại số lượng chó mèo cần cứu hộ đang tăng dần, nhưng số lượng tình nguyện viên còn khá khiêm tốn nên không thể đảm bảo cho việc cứu hộ các bé kịp thời nhanh nhất và tốt nhất.\n',
      ),
      TextSpan(
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
          text:
              ' Chúng tôi rất hy vọng có thêm được sự giúp đỡ từ bạn bằng cách tham gia làm tình nguyện viên cứu hộ.\n\n'),
      TextSpan(
        text:
            'Trước khi đăng ký làm tình nguyện viên cứu hộ, bạn hãy cân nhắc những yêu cầu sau:\n',
      ),
      TextSpan(
          text:
              '- Những công việc này đều là không lương, nhưng lại cần có trách nhiệm và tình cảm thật sự trong đó. Bởi nếu chỉ tham gia cho vui hay ý thích nhất thời thì bạn không thể làm được lâu dài và ảnh hưởng ít nhiều đến các bé.\n'),
      TextSpan(
        text:
            '- Có thời gian (sẽ hạn chế nhận các bạn học sinh đang trong giai đoạn ôn thi).\n',
      ),
      TextSpan(
        text: '- Yêu thương và muốn thực sự góp sức cứu các bé.\n',
      ),
      TextSpan(
        text: '- Có xe máy, chủ động được phương tiện đi lại.\n',
      ),
      TextSpan(
        text:
            '- Tay lái cứng, có thể giúp chuyển các bé về trung tâm cứu hộ, vận chuyển lồng chuồng.\n',
      ),
    ],
  ),
);

loginNotice(BuildContext context) => RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Philosopher',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text:
                'Đăng nhập với Google đồng nghĩa với việc bạn đã đông ý với các ',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          TextSpan(
              text: 'Điều khoản & Điều kiện ',
              style: TextStyle(
                color: color2,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PolicyPage(),
                    ),
                  );
                }),
          TextSpan(
            text: 'của chúng tôi',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );

final appPolicy = RichText(
  text: TextSpan(
    style: TextStyle(
      fontFamily: 'Philosopher',
      color: darkBlue,
    ),
    children: [
      TextSpan(
          style: TextStyle(fontSize: 18),
          text:
              'RescueMe được cấp phép cho Bạn bởi RescueMe Team, có trụ sở tại Thành phố Hồ Chí Minh, Việt Nam (sau đây gọi là Người cấp phép), chỉ để sử dụng theo các điều khoản của Thỏa thuận Cấp phép này. \n\n'),
      TextSpan(
          style: TextStyle(fontSize: 18),
          text:
              'Bằng cách tải xuống từ bất kỳ bản cập nhật nào trong đó (theo sự cho phép của Thỏa thuận cấp phép này), Bạn cho biết rằng Bạn đồng ý bị ràng buộc bởi tất cả các điều khoản và điều kiện của Thỏa thuận cấp phép này và rằng Bạn chấp nhận Thỏa thuận cấp phép này.\n\n'),
      TextSpan(
        style: TextStyle(
          fontSize: 20,
          height: 5,
          fontWeight: FontWeight.bold,
        ),
        text: '1. ỨNG DỤNG\n',
      ),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              'RescueMe (sau đây gọi là Ứng dụng) là một phần mềm được tạo ra để kết nối các trung tâm cứu hộ chó và mèo với các tình nguyện viên và người nhận nuôi - và được tùy chỉnh cho các thiết bị di động Android. Nó được sử dụng để gửi yêu cầu cứu hộ đến các trung tâm hỗ trợ thú cưng, tìm chủ nhân mới và phù hợp nhất cho thú cưng.\n\n'),
      TextSpan(
        style: TextStyle(
          fontSize: 20,
          height: 5,
          fontWeight: FontWeight.bold,
        ),
        text: '2. PHẠM VI GIẤY PHÉP\n',
      ),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              '2.1 Giấy phép này cũng sẽ chi phối mọi bản cập nhật của Ứng dụng do Bên cấp phép cung cấp để thay thế, sửa chữa và / hoặc bổ sung cho Ứng dụng đầu tiên, trừ khi một giấy phép riêng được cung cấp cho bản cập nhật đó, trong trường hợp đó, các điều khoản của giấy phép mới đó sẽ chi phối.\n\n'),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              '2.2 Bạn không được đảo ngược thiết kế, dịch, tháo rời, tích hợp, dịch ngược, tích hợp, loại bỏ, sửa đổi, kết hợp, tạo các sản phẩm phái sinh hoặc cập nhật, điều chỉnh hoặc cố gắng lấy mã nguồn của Ứng dụng hoặc bất kỳ phần nào của nó (ngoại trừ với Sự đồng ý trước bằng văn bản của RescueMe).\n\n'),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              '2.3 Bạn không được sao chép (ngoại trừ khi được cho phép rõ ràng bởi giấy phép này và Quy tắc sử dụng) hoặc thay đổi Ứng dụng hoặc các phần trong đó. Bạn chỉ có thể tạo và lưu trữ các bản sao trên các thiết bị mà Bạn sở hữu hoặc kiểm soát để lưu trữ sao lưu theo các điều khoản của giấy phép này và bất kỳ điều khoản và điều kiện nào khác áp dụng cho thiết bị hoặc phần mềm được sử dụng. Bạn không thể xóa bất kỳ thông báo sở hữu trí tuệ nào. Bạn thừa nhận rằng không có bên thứ ba trái phép nào có thể truy cập vào các bản sao này bất cứ lúc nào.\n\n'),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              '2.4 Vi phạm các nghĩa vụ nêu trên, cũng như cố gắng thực hiện hành vi xâm phạm đó, có thể bị truy tố và bồi thường thiệt hại.\n\n'),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              '2.5 Người cấp phép có quyền sửa đổi các điều khoản và điều kiện của việc cấp phép.\n\n'),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              '2.6 Không có gì trong giấy phép này nên được giải thích để hạn chế các điều khoản của bên thứ ba. Khi sử dụng Ứng dụng, Bạn phải đảm bảo rằng Bạn tuân thủ các điều khoản và điều kiện hiện hành của bên thứ ba\n\n'),
      TextSpan(
        style: TextStyle(
          fontSize: 20,
          height: 5,
          fontWeight: FontWeight.bold,
        ),
        text: '3. YÊU CẦU KỸ THUẬT\n',
      ),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              '3.1 Người cấp phép cố gắng giữ cho Ứng dụng được cập nhật để nó tuân thủ các phiên bản đã sửa đổi / mới của chương trình cơ sở và phần cứng mới. Bạn không được cấp quyền để yêu cầu một bản cập nhật như vậy.\n\n'),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              '3.2 Bạn thừa nhận rằng Bạn có trách nhiệm xác nhận và xác định rằng thiết bị dành cho người dùng cuối ứng dụng mà Bạn dự định sử dụng Ứng dụng đáp ứng các thông số kỹ thuật được đề cập ở trên.\n\n'),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              '3.3 Người cấp phép có quyền sửa đổi các thông số kỹ thuật khi thấy phù hợp vào bất kỳ lúc nào.\n\n'),
      TextSpan(
        style: TextStyle(
          fontSize: 20,
          height: 5,
          fontWeight: FontWeight.bold,
        ),
        text: '4. BẢO TRÌ VÀ HỖ TRỢ\n',
      ),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              'Bên cấp phép hoàn toàn chịu trách nhiệm cung cấp bất kỳ dịch vụ bảo trì và hỗ trợ nào cho Ứng dụng được cấp phép này. Bạn có thể liên hệ với Người cấp phép theo địa chỉ email được liệt kê trong Tổng quan về App cho Ứng dụng được cấp phép này.\n\n'),
      TextSpan(
        style: TextStyle(
          fontSize: 20,
          height: 5,
          fontWeight: FontWeight.bold,
        ),
        text: '5. GIẤy PHÉP ĐÓNG GÓP\n',
      ),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              'Bằng cách đăng Đóng góp của bạn cho bất kỳ phần nào của Ứng dụng hoặc làm cho các Đóng góp có thể truy cập được vào Ứng dụng bằng cách liên kết tài khoản của bạn từ Ứng dụng với bất kỳ tài khoản mạng xã hội nào của bạn, bạn sẽ tự động cấp và bạn tuyên bố và đảm bảo rằng bạn có quyền cấp, cho chúng tôi một quyền không hạn chế, không giới hạn, không thể thu hồi, vĩnh viễn, không độc quyền, có thể chuyển nhượng, miễn phí bản quyền, trả đầy đủ, quyền trên toàn thế giới, và giấy phép để lưu trữ, sử dụng bản sao, tái sản xuất, tiết lộ, bán, bán lại, xuất bản, diễn viên rộng rãi, nghỉ hưu, lưu trữ, lưu trữ, lưu vào bộ nhớ cache, hiển thị công khai, định dạng lại, dịch, truyền tải, trích dẫn (toàn bộ hoặc một phần) và phân phối các Đóng góp đó (bao gồm nhưng không giới hạn, hình ảnh và giọng nói của bạn) cho bất kỳ mục đích nào, quảng cáo thương mại hoặc cách khác, và để chuẩn bị các sản phẩm phái sinh của, hoặc kết hợp vào các công việc khác, chẳng hạn như Đóng góp, và cấp và cho phép cấp phép phụ của những điều đã nói ở trên. Việc sử dụng và phân phối có thể xảy ra ở bất kỳ định dạng phương tiện nào và thông qua bất kỳ kênh phương tiện nào.\n\nGiấy phép này sẽ áp dụng cho bất kỳ hình thức, phương tiện hoặc công nghệ nào hiện đã được biết đến hoặc sau này được phát triển và bao gồm việc chúng tôi sử dụng tên, tên công ty và tên nhượng quyền của bạn, nếu có, và bất kỳ nhãn hiệu, nhãn hiệu dịch vụ, tên thương mại, biểu tượng nào, và hình ảnh cá nhân và thương mại mà bạn cung cấp. Bạn từ bỏ tất cả các quyền nhân thân trong các Đóng góp của mình và bạn đảm bảo rằng các quyền nhân thân chưa được khẳng định trong các Đóng góp của bạn. \nChúng tôi không khẳng định bất kỳ quyền sở hữu nào đối với các Đóng góp của bạn. Bạn có toàn quyền sở hữu tất cả các Đóng góp của mình và mọi quyền sở hữu trí tuệ hoặc các quyền sở hữu khác liên quan đến các Đóng góp của bạn. \n\nChúng tôi không chịu trách nhiệm pháp lý đối với bất kỳ tuyên bố hoặc đại diện nào trong Đóng góp của bạn do bạn cung cấp trong bất kỳ khu vực nào trong Ứng dụng. Bạn hoàn toàn chịu trách nhiệm về các Đóng góp của mình cho Ứng dụng và bạn đồng ý rõ ràng sẽ miễn trừ cho chúng tôi mọi trách nhiệm và không thực hiện bất kỳ hành động pháp lý nào chống lại chúng tôi liên quan đến các Đóng góp của bạn. Chúng tôi có quyền, theo quyết định riêng và tuyệt đối của mình, (1) chỉnh sửa, biên soạn lại hoặc thay đổi bất kỳ Đóng góp nào; (2) phân loại lại bất kỳ Đóng góp nào để đặt chúng vào các vị trí thích hợp hơn trong Ứng dụng; và (3) để sàng lọc trước hoặc xóa bất kỳ Đóng góp nào vào bất kỳ lúc nào và vì bất kỳ lý do gì mà không cần thông báo. Chúng tôi không có nghĩa vụ giám sát các Đóng góp của bạn.\n\n'),
      TextSpan(
        style: TextStyle(
          fontSize: 20,
          height: 5,
          fontWeight: FontWeight.bold,
        ),
        text: '6. TRÁCH NHIỆM PHÁP LÝ\n',
      ),
      TextSpan(
          style: TextStyle(fontSize: 16),
          text:
              'Trách nhiệm của bên cấp phép trong trường hợp vi phạm nghĩa vụ và vi phạm sẽ được giới hạn ở mục đích và sơ suất thô bạo. Chỉ trong trường hợp vi phạm các nghĩa vụ hợp đồng thiết yếu (nghĩa vụ cơ bản), Người cấp phép cũng sẽ phải chịu trách nhiệm trong trường hợp sơ suất nhỏ. Trong mọi trường hợp, trách nhiệm pháp lý sẽ được giới hạn trong những thiệt hại có thể thấy trước, thông thường theo hợp đồng. Giới hạn nêu trên không áp dụng cho các thương tích về tính mạng, chi hoặc sức khỏe.\n\n'),
    ],
  ),
);
