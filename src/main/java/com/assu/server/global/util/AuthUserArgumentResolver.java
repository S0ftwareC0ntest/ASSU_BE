package com.assu.server.global.util;

import com.assu.server.domain.common.entity.Member;
import com.assu.server.global.apiPayload.code.status.ErrorStatus;
import com.assu.server.global.exception.exception.GeneralException;
import lombok.RequiredArgsConstructor;
import org.springframework.core.MethodParameter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@Component
@RequiredArgsConstructor
public class AuthUserArgumentResolver implements HandlerMethodArgumentResolver {

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.getParameterType().equals(Member.class);
    }

    @Override
    public Object resolveArgument(
            MethodParameter parameter,
            ModelAndViewContainer mavContainer,
            NativeWebRequest webRequest,
            WebDataBinderFactory binderFactory)
            throws GeneralException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            return null; // 로그인하지 않은 사용자
        }

        if (authentication.getPrincipal() instanceof PrincipalDetails principalDetails) {
            return principalDetails.getMember();
        }

        throw new GeneralException(ErrorStatus.NO_SUCH_MEMBER);
    }
}
